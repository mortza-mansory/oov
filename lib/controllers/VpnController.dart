import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import 'package:oov/unit/models/vpnConfig.dart';

class VpnController extends GetxController {
  late OpenVPN openvpn;
  var vpnStatus = VpnStatus().obs;
  var vpnStage = VPNStage.disconnected.obs;
  var isConnecting = false.obs;
  var selectedConfig = Rxn<VpnConfig>();
  var vpnConfigs = <VpnConfig>[].obs;
  var pingMs = 0.0.obs; // پینگ به میلی‌ثانیه
  var networkQuality = 'Poor'.obs; // کیفیت شبکه

  @override
  void onInit() {
    super.onInit();
    openvpn = OpenVPN(
      onVpnStatusChanged: _onVpnStatusChanged,
      onVpnStageChanged: _onVpnStageChanged,
    );

    openvpn.initialize(
      groupIdentifier: "group.com.example.oov",
      providerBundleIdentifier: "com.example.oov.VPNExtension",
      localizedDescription: "XStack VPN",
    ).then((_) {
      print("OpenVPN initialized successfully");
    }).catchError((e) {
      print("Error initializing OpenVPN: $e");
      //Get.snackbar("Initialization Error", "Failed to initialize OpenVPN: $e");
    });

    loadDefaultVpnConfig();
    _startPingMonitor(); // شروع نظارت بر پینگ
  }

  Future<void> loadDefaultVpnConfig() async {
    try {
      // اطلاعات یوزرنیم و پسورد
      const ovpnUsername = '230740503_79fa5bcf405469fa2faa1fa2489056b56b922811';
      const ovpnPassword = 'f22bf70c56d415e78bd86ffb2596d88821b68fcf';

      // بارگذاری فایل OVPN.ovpn
      const filePath = 'assets/config/OVPN.ovpn';
      final configContent = await rootBundle.loadString(filePath);

      vpnConfigs.clear(); // پاک کردن لیست قبلی

      // اضافه کردن فقط یک کانفیگ
      var defaultConfig = VpnConfig(
        name: 'XStack VPN',
        config: configContent,
        username: ovpnUsername,
        password: ovpnPassword,
      );
      vpnConfigs.add(defaultConfig);
   //   print("Loaded config: ${defaultConfig.name}");

      // تنظیم کانفیگ پیش‌فرض
      if (vpnConfigs.isNotEmpty) {
        selectedConfig.value = vpnConfigs.first;
      //  print("Selected default VPN config: ${selectedConfig.value!.name}");
      } else {
        print("No VPN configs loaded");
      //  Get.snackbar("Error", "No VPN configurations loaded");
      }

      print("Total loaded configs: ${vpnConfigs.length}");
      vpnConfigs.refresh();
      _validateConfig(configContent);
    } catch (e) {
      print("Error loading VPN config: $e");
   //   Get.snackbar("Error", "Failed to load OVPN configuration: $e");
    }
  }

  // تابع برای محاسبه پینگ به سرور
  Future<void> _pingServer() async {
    if (selectedConfig.value == null) return;

    // استخراج آدرس سرور از فایل کانفیگ
    final config = selectedConfig.value!.config;
    final remoteMatch = RegExp(r'remote\s+([\d\.]+)\s+\d+').firstMatch(config);
    final serverIp = remoteMatch?.group(1) ?? '8.8.8.8'; // در صورت عدم یافتن، به Google DNS پینگ می‌کند

    try {
      final result = await Process.run('ping', ['-c', '1', serverIp]);
      if (result.exitCode == 0) {
        final output = result.stdout as String;
        final timeMatch = RegExp(r'time=(\d+\.?\d*)').firstMatch(output);
        if (timeMatch != null) {
          pingMs.value = double.parse(timeMatch.group(1)!);
          _updateNetworkQuality();
          print("Ping to $serverIp: ${pingMs.value} ms");
        } else {
          pingMs.value = 0.0;
          networkQuality.value = 'Poor';
        }
      } else {
        pingMs.value = 0.0;
        networkQuality.value = 'Poor';
       // print("Ping failed: ${result.stderr}");
      }
    } catch (e) {
      pingMs.value = 0.0;
      networkQuality.value = 'Poor';
      print("Error pinging $serverIp: $e");
    }
  }

  // نظارت دوره‌ای بر پینگ
  void _startPingMonitor() {
    Future.doWhile(() async {
      await _pingServer();
      await Future.delayed(Duration(seconds: 5)); // هر 5 ثانیه پینگ
      return true;
    });
  }

  // به‌روزرسانی کیفیت شبکه بر اساس پینگ
  void _updateNetworkQuality() {
    if (pingMs.value >= 100 && pingMs.value <= 200) {
      networkQuality.value = 'Excellent';
    } else if (pingMs.value > 200 && pingMs.value <= 500) {
      networkQuality.value = 'Good';
    } else {
      networkQuality.value = 'Poor';
    }
    print("Network Quality: ${networkQuality.value}");
  }

  // تبدیل بایت به مگابایت بر ثانیه
  String _bytesToMBps(String? bytes) {
    if (bytes == null || bytes.isEmpty || bytes == '0') return '0.00 MB/s';
    try {
      final bytesPerSecond = int.parse(bytes.replaceAll(RegExp(r'[^0-9]'), '')) / 1000000; // تبدیل به MB/s
      return '${bytesPerSecond.toStringAsFixed(2)} MB/s';
    } catch (e) {
      return '0.00 MB/s';
    }
  }

  void selectConfig(VpnConfig config) {
    selectedConfig.value = config;
    print("Selected VPN config: ${config.name}");
  //  Get.snackbar("Info", "Selected VPN: ${config.name}");
    if (vpnStage.value != VPNStage.disconnected) {
      disconnectVPN();
    }
    connectVPN(); // اتصال خودکار پس از انتخاب
    update();
  }

  void _validateConfig(String configContent) {
    if (configContent.contains('auth-user-pass') &&
        (selectedConfig.value?.username == null ||
            selectedConfig.value?.password == null)) {
      print("Warning: auth-user-pass detected but no username/password provided");
     // Get.snackbar("Warning", "VPN config requires username/password.");
    }
    if (!configContent.contains('ca') && !configContent.contains('<ca>')) {
      print("Warning: No CA certificate found in .ovpn file");
  //    Get.snackbar("Warning", "No CA certificate found.");
    }
  }

  void _onVpnStatusChanged(VpnStatus? status) {
    if (status != null) {
      vpnStatus.value = VpnStatus(
        duration: status.duration,
        byteIn: _bytesToMBps(status.byteIn), // تبدیل به MB/s
        byteOut: _bytesToMBps(status.byteOut), // تبدیل به MB/s
      );
      print("VPN Status: duration=${status.duration}, byteIn=${vpnStatus.value.byteIn}, byteOut=${vpnStatus.value.byteOut}");
      update();
    }
  }

  void _onVpnStageChanged(VPNStage? stage, String? raw) {
    vpnStage.value = stage ?? VPNStage.disconnected;
    print("VPN Stage: $stage, Raw: $raw");
    switch (vpnStage.value) {
      case VPNStage.error:
        isConnecting.value = false;
      //  Get.snackbar("VPN Error", "Failed to connect: $raw");
        break;
      case VPNStage.connected:
        isConnecting.value = false;
    //    Get.snackbar("Success", "VPN connected successfully!");
        break;
      case VPNStage.disconnected:
        isConnecting.value = false;
     //   Get.snackbar("Info", "VPN disconnected");
        break;
      case VPNStage.connecting:
      case VPNStage.wait_connection:
      case VPNStage.vpn_generate_config:
      case VPNStage.resolve:
        isConnecting.value = true;
      //  Get.snackbar("Info", "Connecting to VPN...");
        break;
      default:
        isConnecting.value = false;
        print("Unknown VPN stage: $stage");
      //  Get.snackbar("Warning", "Unknown VPN stage: $stage");
    }
    update();
  }

  Future<void> connectVPN() async {
    if (vpnStage.value != VPNStage.disconnected) {
      print("Disconnecting VPN because current stage is: ${vpnStage.value}");
      disconnectVPN();
      return;
    }

    if (selectedConfig.value == null) {
      print("No VPN configuration loaded");
    //  Get.snackbar("Error", "No VPN configuration loaded");
      return;
    }

    try {
      isConnecting.value = true;
      print("Attempting to connect to VPN: ${selectedConfig.value!.name}");
      await openvpn.connect(
        selectedConfig.value!.config,
        selectedConfig.value!.name,
        username: selectedConfig.value!.username,
        password: selectedConfig.value!.password,
        certIsRequired: true,
        bypassPackages: [],
      );
      print("VPN connection initiated");
    } catch (e) {
      print("Error during VPN connection: $e");
      isConnecting.value = false;
    //  Get.snackbar("Connection Error", "Failed to connect: $e");
    }
  }

  void disconnectVPN() {
    openvpn.disconnect();
    isConnecting.value = false;
    print("VPN disconnected");
    update();
  }
}