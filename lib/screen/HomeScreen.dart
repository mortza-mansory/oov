import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import '../controllers/VpnController.dart';
import '../utils/theme.dart';

class HomeScreen extends StatelessWidget {
  final VpnController vpnController = Get.put(VpnController());

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.gradientBackground,
        ),
        child: Obx(
              () => Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(w*0.04, 40, w*0.04, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.settings_outlined,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Pro Buy Clicked");
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.nights_stay_outlined,
                          color: Colors.white60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  vpnController.vpnStatus.value.duration ?? "00:00:00",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shield,
                    color: vpnController.vpnStage.value == VPNStage.connected
                        ? Colors.greenAccent
                        : vpnController.vpnStage.value == VPNStage.connecting ||
                        vpnController.vpnStage.value ==
                            VPNStage.wait_connection
                        ? Colors.yellowAccent
                        : Colors.redAccent,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    vpnController.vpnStage.value == VPNStage.connected
                        ? "CONNECTED"
                        : vpnController.vpnStage.value == VPNStage.connecting ||
                        vpnController.vpnStage.value ==
                            VPNStage.wait_connection
                        ? "CONNECTING"
                        : "DISCONNECTED",
                    style: TextStyle(
                      color: vpnController.vpnStage.value == VPNStage.connected
                          ? Colors.greenAccent
                          : vpnController.vpnStage.value == VPNStage.connecting ||
                          vpnController.vpnStage.value ==
                              VPNStage.wait_connection
                          ? Colors.yellowAccent
                          : Colors.redAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  vpnController.connectVPN();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            vpnController.vpnStage.value == VPNStage.connected
                                ? Colors.greenAccent.withOpacity(0.5)
                                : vpnController.vpnStage.value ==
                                VPNStage.connecting ||
                                vpnController.vpnStage.value ==
                                    VPNStage.wait_connection
                                ? Colors.yellowAccent.withOpacity(0.5)
                                : const Color.fromARGB(255, 49, 41, 97)
                                .withOpacity(0.5),
                            vpnController.vpnStage.value == VPNStage.connected
                                ? Colors.greenAccent.withOpacity(0.3)
                                : vpnController.vpnStage.value ==
                                VPNStage.connecting ||
                                vpnController.vpnStage.value ==
                                    VPNStage.wait_connection
                                ? Colors.yellowAccent.withOpacity(0.3)
                                : const Color.fromARGB(255, 49, 41, 97)
                                .withOpacity(0.3),
                          ],
                          center: Alignment.center,
                          radius: 0.8,
                        ),
                        border: Border.all(
                          width: 14,
                          color: vpnController.vpnStage.value == VPNStage.connected
                              ? Colors.greenAccent.withOpacity(0.5)
                              : vpnController.vpnStage.value ==
                              VPNStage.connecting ||
                              vpnController.vpnStage.value ==
                                  VPNStage.wait_connection
                              ? Colors.yellowAccent.withOpacity(0.5)
                              : Colors.black12,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: vpnController.vpnStage.value == VPNStage.connected
                            ? Colors.greenAccent.withOpacity(0.5)
                            : vpnController.vpnStage.value ==
                            VPNStage.connecting ||
                            vpnController.vpnStage.value ==
                                VPNStage.wait_connection
                            ? Colors.yellowAccent.withOpacity(0.5)
                            : const Color.fromARGB(255, 62, 56, 127),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outlined,
                            color: Colors.white,
                            size: 60,
                            weight: 10,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            vpnController.vpnStage.value == VPNStage.connected
                                ? "Connected"
                                : vpnController.vpnStage.value ==
                                VPNStage.connecting ||
                                vpnController.vpnStage.value ==
                                    VPNStage.wait_connection
                                ? "Connecting"
                                : "Disconnected",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            vpnController.selectedConfig.value?.name ??
                                "XStack VPN",
                            style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.fromLTRB(w*0.18, 10, w*0.2, 0),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360),
                        color: Colors.deepPurpleAccent,
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Upload",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          vpnController.vpnStatus.value.byteOut ?? "0.00 MB/s",
                          style: const TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(360),
                        color: Colors.greenAccent.shade400,
                      ),
                      child: const Icon(
                        Icons.cloud_download_outlined,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Download",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          vpnController.vpnStatus.value.byteIn ?? "0.00 MB/s",
                          style: TextStyle(
                            color: Colors.greenAccent.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    isDismissible: true,
                    Container(
                      height: 700,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white30, width: 2),
                        ),
                        color: Color.fromARGB(255, 45, 48, 65),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white24,
                              ),
                              height: 8,
                              width: 120,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Locations",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  width: 130,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: Colors.black45,
                                    border: Border.all(
                                      color: Colors.white24,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color:
                                          const Color.fromARGB(255, 88, 48, 158),
                                          borderRadius: BorderRadius.circular(360),
                                        ),
                                        height: 20,
                                        width: 20,
                                        child: const Icon(
                                          Icons.assistant_photo_rounded,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      const Text(
                                        "Go Premium",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: const [
                                Text(
                                  "Free",
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "VPNS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Obx(
                                    () => vpnController.vpnConfigs.isEmpty
                                    ? const Center(
                                  child: Text(
                                    "No VPN configurations available",
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                )
                                    : ListView.builder(
                                  itemCount: vpnController.vpnConfigs.length,
                                  itemBuilder: (context, index) {
                                    final config =
                                    vpnController.vpnConfigs[index];
                                    return ListTile(
                                      leading: const Icon(
                                          Icons.vpn_lock,
                                          color: Colors.white),
                                      title: Text(
                                        config.name,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        "Location: ${config.name}",
                                        style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 10),
                                      ),
                                      trailing: Icon(
                                        config ==
                                            vpnController
                                                .selectedConfig.value
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        vpnController.selectConfig(config);
                                        Get.back();
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    isScrollControlled: true,
                    barrierColor: const Color.fromARGB(237, 0, 0, 0),
                  );
                },
                child: Container(
                  width: w*0.95,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.flag_circle_rounded,
                        color: Colors.white70,
                        size: 45,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vpnController.selectedConfig.value?.name ??
                                "XStack VPN",
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.white12,
                                size: 20,
                              ),
                              Text(
                                "Location",
                                style: TextStyle(
                                    color: Colors.white24, fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(width: w*0.2),
                      const Icon(
                        Icons.signal_cellular_alt,
                        color: Colors.deepPurpleAccent,
                      ),
                      Text(
                        "${vpnController.pingMs.value.toStringAsFixed(0)}ms",
                        style: const TextStyle(
                          color: Colors.white24,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: w*0.1),

                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "${vpnController.pingMs.value.toStringAsFixed(0)} ms",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "Current delay",
                                    style: TextStyle(
                                      color: Colors.white30,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    vpnController.networkQuality.value,
                                    style: TextStyle(
                                      color: Colors.deepPurpleAccent.shade400,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "Network Quality",
                                    style: TextStyle(
                                      color: Colors.white30,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "${vpnController.pingMs.value.toStringAsFixed(0)} ms",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    "Advance",
                                    style: TextStyle(
                                      color: Colors.white30,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}