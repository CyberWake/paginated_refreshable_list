import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PaginatedRefreshableListGenerator<T> extends StatefulWidget {
  const PaginatedRefreshableListGenerator({
    Key? key,
    this.initialData,
    this.loadingWidget,
    this.noDataWidget,
    this.loadingBuilderCount,
    this.startPageRenderFrom = 1,
    required this.itemLoadCount,
    required this.builder,
    required this.fetchList,
    this.loadingBuilder,
  }) : super(key: key);
  final List<T>? initialData;
  final Widget? loadingWidget;
  final Widget? noDataWidget;
  final int? loadingBuilderCount;
  final int startPageRenderFrom;
  final int itemLoadCount;
  final Widget Function(
    BuildContext context,
    int index,
    T currentItem,
    bool isLastListItem,
  ) builder;
  final Future<List<T>> Function(
    int itemToLoad,
    int pageToRequest,
    int itemsLoaded,
  ) fetchList;
  final Widget Function(BuildContext context, int index)? loadingBuilder;

  @override
  State<PaginatedRefreshableListGenerator<T>> createState() =>
      PaginatedRefreshableListGeneratorState<T>();
}

class PaginatedRefreshableListGeneratorState<T>
    extends State<PaginatedRefreshableListGenerator<T>> {
  final List<T> items = [];
  bool isMaxLoaded = false;
  late int requestPage;

  bool get showLoadingListItems =>
      !isMaxLoaded && items.isEmpty && widget.loadingBuilder != null;
  bool get showLoadingList =>
      !isMaxLoaded && items.isEmpty && widget.loadingBuilder == null;
  bool get showNoData => isMaxLoaded && items.isEmpty;

  @override
  void initState() {
    if (widget.initialData != null) {
      items.addAll(widget.initialData!);
    }
    requestPage = widget.startPageRenderFrom;
    fetchItems();
    super.initState();
  }

  Future fetchItems() async {
    final newItems = await widget.fetchList
        .call(widget.itemLoadCount, requestPage, items.length);
    if (newItems.isEmpty) {
      setState(() {
        isMaxLoaded = true;
      });
    } else {
      setState(() {
        items.addAll(newItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget loaderWidget = widget.loadingWidget ??
        widget.loadingBuilder?.call(context, 0) ??
        Center(
          child: Platform.isAndroid
              ? const CircularProgressIndicator()
              : const CupertinoActivityIndicator(),
        );
    return Column(
      children: showLoadingListItems
          ? List.generate(
              widget.loadingBuilderCount!,
              (index) => widget.loadingBuilder!.call(context, index),
            )
          : showLoadingList
              ? [loaderWidget]
              : showNoData
                  ? [
                      widget.noDataWidget ??
                          const Center(
                            child: Text('No Data to show'),
                          )
                    ]
                  : List.generate(
                      isMaxLoaded ? items.length : items.length + 1,
                      (index) {
                        if (index == items.length) {
                          return VisibilityDetector(
                            key: UniqueKey(),
                            child: loaderWidget,
                            onVisibilityChanged: (VisibilityInfo info) {
                              if (info.visibleFraction > 0 && !isMaxLoaded) {
                                requestPage += 1;
                                fetchItems();
                              }
                            },
                          );
                        }
                        return widget.builder.call(
                          context,
                          index,
                          items[index],
                          index == items.length,
                        );
                      },
                    ),
    );
  }
}
