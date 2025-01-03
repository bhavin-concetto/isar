import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;

final _markdownHtmlPod = Provider.family<String, String>((ref, source) {
  return md.markdownToHtml(
    source,
    extensionSet: md.ExtensionSet.gitHubWeb,
  );
});

class MarkdownViewer extends ConsumerWidget {
  const MarkdownViewer({required this.markdown, super.key});

  final String markdown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final html = ref.read(_markdownHtmlPod(markdown));
    return const Text("data");
    // return Html(
    //   data: html,
    //   onLinkTap: (url, context, attributes) {
    //     if (url != null) {
    //       launchUrlString(url);
    //     }
    //   },
    //   customRenders: {
    //     svgTagMatcher(): svgTagRender(),
    //     svgDataUriMatcher(): svgDataImageRender(),
    //     svgAssetUriMatcher(): svgAssetImageRender(),
    //     svgNetworkSourceMatcher(): svgNetworkImageRender(),
    //     tagMatcher('code'): CustomRender.widget(
    //       widget: (context, children) {
    //         final code = context.tree.element!.text;
    //         final codeBgColor =
    //             theme.colorScheme.secondaryContainer.withOpacity(0.25);
    //         if (code.contains('\n')) {
    //           return FadingScroll(
    //             builder: (context, controller) {
    //               return SingleChildScrollView(
    //                 scrollDirection: Axis.horizontal,
    //                 controller: controller,
    //                 child: Container(
    //                   padding: const EdgeInsets.all(15),
    //                   decoration: BoxDecoration(
    //                     color: codeBgColor,
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                   child: SelectableText(
    //                     code.trim(),
    //                     style: GoogleFonts.jetBrainsMono(
    //                       color: theme.colorScheme.onSecondaryContainer,
    //                     ),
    //                   ),
    //                 ),
    //               );
    //             },
    //           );
    //         } else {
    //           return SelectableText(
    //             code.trim(),
    //             style: GoogleFonts.jetBrainsMono(
    //               backgroundColor: codeBgColor,
    //               color: theme.colorScheme.onSecondaryContainer,
    //             ),
    //           );
    //         }
    //       },
    //     ),
    //     tagMatcher('h1'): CustomRender.widget(
    //       widget: (context, children) {
    //         return Container(
    //           width: double.infinity,
    //           padding: const EdgeInsets.only(bottom: 5),
    //           decoration: BoxDecoration(
    //             border: Border(
    //               bottom: BorderSide(color: theme.dividerColor),
    //             ),
    //           ),
    //           child: Text(
    //             context.tree.element!.text,
    //             style: context.tree.style.generateTextStyle(),
    //           ),
    //         );
    //       },
    //     ),
    //     tagMatcher('h2'): CustomRender.widget(
    //       widget: (context, children) {
    //         return Container(
    //           width: double.infinity,
    //           padding: const EdgeInsets.only(bottom: 5),
    //           decoration: BoxDecoration(
    //             border: Border(
    //               bottom: BorderSide(color: theme.dividerColor),
    //             ),
    //           ),
    //           child: Text(
    //             context.tree.element!.text,
    //             style: context.tree.style.generateTextStyle(),
    //           ),
    //         );
    //       },
    //     ),
    //   },
    // );
  }
}
