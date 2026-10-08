import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../../../core/constants/app_colors.dart';

/// In-app WebView page to display YouTube recipe videos seamlessly.
class YoutubeWebViewPage extends StatefulWidget {
  const YoutubeWebViewPage({
    super.key,
    required this.url,
    required this.title,
  });

  final String url;
  final String title;

  @override
  State<YoutubeWebViewPage> createState() => _YoutubeWebViewPageState();
}

class _YoutubeWebViewPageState extends State<YoutubeWebViewPage> {
  WebViewController? _controller;
  bool _isValidUrl = false;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _progress = 0;
  String _normalizedUrl = '';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    final raw = widget.url.trim();
    if (raw.isEmpty) {
      _isValidUrl = false;
      _isLoading = false;
      return;
    }

    String urlToLoad = raw;
    if (urlToLoad.startsWith('http://')) {
      urlToLoad = 'https://${urlToLoad.substring(7)}';
    } else if (!urlToLoad.startsWith('https://')) {
      urlToLoad = 'https://$urlToLoad';
    }

    final uri = Uri.tryParse(urlToLoad);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      _isValidUrl = false;
      _isLoading = false;
      return;
    }

    _isValidUrl = true;
    _normalizedUrl = urlToLoad;

    // Ensure platform implementation is registered
    if (WebViewPlatform.instance == null) {
      try {
        if (!kIsWeb && Platform.isAndroid) {
          AndroidWebViewPlatform.registerWith();
        }
      } catch (e) {
        debugPrint('Dynamic AndroidWebViewPlatform registration failed: $e');
      }
    }

    if (WebViewPlatform.instance == null) {
      setState(() {
        _hasError = true;
        _errorMessage =
            'In-app WebView native engine is not attached yet. Please restart the Flutter app (flutter run) to compile the native plugin.';
        _isLoading = false;
      });
      return;
    }

    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(AppColors.background)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              if (mounted) {
                setState(() {
                  _progress = progress;
                  if (progress >= 100) {
                    _isLoading = false;
                  }
                });
              }
            },
            onPageStarted: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
              }
            },
            onPageFinished: (String url) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            onWebResourceError: (WebResourceError error) {
              if (error.isForMainFrame ?? true) {
                if (mounted) {
                  setState(() {
                    _hasError = true;
                    _errorMessage = error.description;
                    _isLoading = false;
                  });
                }
              }
            },
          ),
        )
        ..loadRequest(uri);
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'Could not initialize in-app player ($e). Please restart the app.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleBackPress() async {
    if (_controller != null && await _controller!.canGoBack()) {
      await _controller!.goBack();
    } else {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _launchExternal() async {
    final uri = Uri.tryParse(_normalizedUrl);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackPress();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
            tooltip: 'Back to Meal Details',
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFFFF0000),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'YouTube Video Recipe',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            if (_isValidUrl) ...[
              IconButton(
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                tooltip: 'Reload',
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _isLoading = true;
                  });
                  if (_controller != null) {
                    _controller!.reload();
                  } else {
                    _initWebView();
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.open_in_browser_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
                tooltip: 'Open in Browser',
                onPressed: _launchExternal,
              ),
              const SizedBox(width: 6),
            ],
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: AppColors.border,
              height: 1,
            ),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (!_isValidUrl) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF0000).withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.videocam_off_rounded,
                  color: Color(0xFFFF0000),
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Invalid YouTube Link',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.url.isEmpty
                    ? 'No YouTube video link is available for this recipe.'
                    : 'The provided link "${widget.url}" is not a valid URL.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Back to Meal Details'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  color: AppColors.error,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Failed to Load Video',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _errorMessage.isNotEmpty
                    ? _errorMessage
                    : 'Unable to connect to YouTube. Please check your network.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              // Direct fallback action
              ElevatedButton.icon(
                onPressed: _launchExternal,
                icon: const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Color(0xFFFF0000),
                  size: 20,
                ),
                label: const Text('Open in YouTube App / Browser'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: Color(0xFFFF0000)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _isLoading = true;
                      });
                      if (_controller != null) {
                        _controller!.reload();
                      } else {
                        _initWebView();
                      }
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        if (_controller != null) WebViewWidget(controller: _controller!),
        if (_isLoading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: _progress > 0 && _progress < 100
                  ? _progress / 100.0
                  : null,
              backgroundColor: AppColors.surface,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFF0000),
              ),
              minHeight: 3,
            ),
          ),
      ],
    );
  }
}
