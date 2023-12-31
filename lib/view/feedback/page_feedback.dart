
import 'package:flutter/material.dart';

import 'feedback.dart';

class PageFeedBack {
  final bool firstRefresh; // 是否首次加载
  final bool loading; // 是否在加载
  final bool error; // 是否异常
  final bool empty; // 是否空
  final String firstRefreshMsg; // 首次加载内容
  final String errorMsg; // 异常内容
  final String errorButtonText; // 异常重试按钮文字
  final String emptyMsg; // 空数据内容
  final String emptyButtonText; // 空数据重试按钮文字
  final VoidCallback? onErrorTap; // 异常重试回调
  final VoidCallback? onEmptyTap; // 空数据重试回调

  const PageFeedBack({
    this.firstRefresh = false,
    this.loading = true,
    this.error = false,
    this.empty = true,
    this.firstRefreshMsg = 'Loading...',
    this.errorMsg = 'Unknown error.',
    this.errorButtonText = 'Tap to retry',
    this.emptyMsg = 'No data.',
    this.emptyButtonText = 'Tap to retry',
    this.onErrorTap,
    this.onEmptyTap,
  });

  Widget? build() {
    if (firstRefresh) {
      return FeedBack(
        imageType: ImageType.loading,
        description: firstRefreshMsg,
      );
    }
    if (loading) return null;
    if (error) {
      return FeedBack(
        imageType: ImageType.error,
        description: errorMsg,
        showButton: true,
        buttonText: errorButtonText,
        onTap: onErrorTap,
      );
    }
    if (empty) {
      return FeedBack(
        imageType: ImageType.empty,
        description: emptyMsg,
        showButton: true,
        buttonText: emptyButtonText,
        onTap: onEmptyTap,
      );
    }
    return null;
  }
}