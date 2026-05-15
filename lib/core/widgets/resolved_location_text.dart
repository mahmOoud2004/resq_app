import 'package:flutter/material.dart';
import 'package:resq_app/features/map/services/location_service.dart';

class ResolvedLocationText extends StatelessWidget {
  final double latitude;
  final double longitude;
  final TextStyle? style;
  final int maxLines;
  final TextOverflow overflow;
  final String fallbackLabel;
  final String? prefix;

  const ResolvedLocationText({
    super.key,
    required this.latitude,
    required this.longitude,
    this.style,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.fallbackLabel = 'Current location',
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    final safeFallback = prefix == null ? fallbackLabel : '$prefix$fallbackLabel';

    return FutureBuilder<String>(
      future: LocationService().getAddressFromLatLng(latitude, longitude),
      builder: (context, snapshot) {
        final resolved = snapshot.data?.trim();
        final text = (resolved != null && resolved.isNotEmpty)
            ? (prefix == null ? resolved : '$prefix$resolved')
            : safeFallback;

        return Text(
          text,
          maxLines: maxLines,
          overflow: overflow,
          style: style,
        );
      },
    );
  }
}
