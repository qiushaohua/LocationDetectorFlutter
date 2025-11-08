import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/location_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('定位设备检测器'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Consumer<LocationService>(
        builder: (context, locationService, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),

                  // 检测按钮
                  ElevatedButton(
                    onPressed: locationService.isLoading
                        ? null
                        : () => locationService.checkLocation(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                    ),
                    child: locationService.isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            '检测',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),

                  const SizedBox(height: 40),

                  // 结果展示区
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '检测结果',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Divider(),
                        const SizedBox(height: 15),

                        // 外部设备状态
                        _buildResultRow(
                          '外部定位设备状态:',
                          locationService.externalDeviceStatus,
                          locationService.isUsingExternalDevice
                              ? Colors.green
                              : Colors.orange,
                        ),

                        const SizedBox(height: 15),
                        const Divider(),
                        const SizedBox(height: 15),

                        // 位置信息标题
                        const Text(
                          '位置信息:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 纬度
                        _buildResultRow(
                          '纬度:',
                          locationService.latitude,
                          Colors.blue,
                        ),

                        const SizedBox(height: 10),

                        // 经度
                        _buildResultRow(
                          '经度:',
                          locationService.longitude,
                          Colors.blue,
                        ),

                        const SizedBox(height: 10),

                        // 精度
                        _buildResultRow(
                          '精度:',
                          locationService.accuracy,
                          Colors.blue,
                        ),

                        // 错误信息
                        if (locationService.errorMessage.isNotEmpty) ...[
                          const SizedBox(height: 15),
                          const Divider(),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red[200]!),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, color: Colors.red[700]),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    locationService.errorMessage,
                                    style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 提示信息
                  Card(
                    color: Colors.blue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue[700]),
                              const SizedBox(width: 10),
                              Text(
                                '使用提示',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '• 点击"检测"按钮获取当前位置信息\n'
                            '• 首次使用需要授予位置权限\n'
                            '• 外部GPS设备检测需要蓝牙权限\n'
                            '• 在室外开阔环境下精度更高',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[900],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
