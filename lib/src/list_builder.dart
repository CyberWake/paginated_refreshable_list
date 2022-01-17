import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginated_refreshable_list/src/helpers/refresh_indicator_config.dart';
import 'package:paginated_refreshable_list/src/helpers/scrollbar_config.dart';
import 'package:visibility_detector/visibility_detector.dart';

///[PaginatedRefreshableListBuilder]
///
class PaginatedRefreshableListBuilder<T> extends StatefulWidget {
  ///This package come with the following feature
  ///
  ///• Render paginated list
  ///
  ///• Show loading more data widget
  ///
  ///• Refresh whole list
  ///
  /// Usage:
  ///```dart
  /// //(Player is a dart class passed which makes the widget a typed widget)
  ///RefreshLazyLoadingListBuilder<Player>(
  ///  fetchList: fetchPlayerList,
  ///  itemLoadCount: 10, //(optional param)
  ///  loadingListBuilder: (context, index) {  //(optional param)
  ///    return Container(
  ///      color: Colors.red[(index + 1) * 100],
  ///      height: 100,
  ///     );
  ///  },
  ///  noDataWidget
  ///  loadingBuilderItemCount: 3,
  ///  loadingWidget: const Center(child: Text('Loading data')),  //(optional)
  ///  builder: (context, index, currentItem, isLastItem) {
  ///    return UpdateProfilePlayerTile(
  ///      onTap: () => selectPlayer(currentItem),
  ///      currentPlayer: currentItem,
  ///      isSelected: currentItem == selectedPlayer,
  ///      showSeparator: !isLastItem
  ///    );
  ///  },
  ///),
  const PaginatedRefreshableListBuilder({
    Key? key,
    required this.fetchList,
    required this.builder,
    this.loadingListBuilder,
    this.loadingBuilderItemCount,
    this.initialData,
    this.loadingWidget,
    this.noDataWidget,
    this.physics,
    this.listPadding,
    this.refreshTriggerMode,
    this.scrollConfig,
    this.startPageRenderFrom = 1,
    required this.itemLoadCount,
    this.shrinkWrap = false,
    this.refreshConfig,
  })  : assert(
          (loadingListBuilder == null && loadingBuilderItemCount == null) ||
              (loadingListBuilder != null && loadingBuilderItemCount != null),
          'Please pass the loadingBuilderItemCount` when using loadingBuilder',
        ),
        super(key: key);
  final int startPageRenderFrom;
  final int itemLoadCount;
  final bool shrinkWrap;
  final Future<List<T>> Function(
    int itemToLoad,
    int pageToRequest,
    int itemsLoaded,
  ) fetchList;
  final Widget Function(
    BuildContext context,
    int index,
    T currentItem,
    bool isLastListItem,
  ) builder;
  final int? loadingBuilderItemCount;
  final List<T>? initialData;
  final Widget? loadingWidget;
  final Widget? noDataWidget;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? listPadding;
  final RefreshIndicatorTriggerMode? refreshTriggerMode;
  final ScrollConfig? scrollConfig;
  final RefreshIndicatorConfig? refreshConfig;
  final Widget Function(
    BuildContext context,
    int index,
  )? loadingListBuilder;

  @override
  State<PaginatedRefreshableListBuilder<T>> createState() =>
      _PaginatedRefreshableListBuilderState<T>();
}

class _PaginatedRefreshableListBuilderState<T>
    extends State<PaginatedRefreshableListBuilder<T>>
    with AutomaticKeepAliveClientMixin {
  final ScrollController controller = ScrollController();
  final List<T> items = [];
  final Widget defaultLoaderWidget = Container(
    margin: const EdgeInsets.all(16.0),
    alignment: Alignment.center,
    child: FittedBox(
      child: Platform.isAndroid
          ? const CircularProgressIndicator()
          : const CupertinoActivityIndicator(radius: 15),
    ),
  );
  late int requestPage;
  ScrollConfig _scrollConfig = ScrollConfig();
  RefreshIndicatorConfig _refreshConfig = RefreshIndicatorConfig();
  bool isMaxLoaded = false;
  bool isLoading = false;

  bool get showLoadingListItems =>
      !isMaxLoaded && items.isEmpty && widget.loadingListBuilder != null;
  bool get showLoadingItem =>
      !isMaxLoaded && items.isEmpty && widget.loadingListBuilder == null;
  bool get showNoData => isMaxLoaded && items.isEmpty;

  @override
  void initState() {
    requestPage = widget.startPageRenderFrom;
    if (widget.initialData != null) {
      items.addAll(widget.initialData!);
    }
    if (widget.scrollConfig != null) {
      _scrollConfig = widget.scrollConfig!;
    }
    if (widget.refreshConfig != null) {
      _refreshConfig = widget.refreshConfig!;
    }
    fetchItems();
    super.initState();
  }

  Future fetchItems({bool isRefresh = false}) async {
    if (isRefresh) {
      requestPage = widget.startPageRenderFrom;
      if (items.isEmpty) {
        setState(() {
          isMaxLoaded = false;
        });
      } else {
        isMaxLoaded = false;
        items.clear();
      }
    } else {
      isLoading = true;
    }
    final newItems = await widget.fetchList
        .call(widget.itemLoadCount, requestPage, items.length);
    if (newItems.isEmpty) {
      setState(() {
        isMaxLoaded = true;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        items.addAll(newItems);
      });
    }
  }

  int getListLength() {
    if (isMaxLoaded) {
      if (items.isEmpty) {
        return 1;
      } else {
        return items.length;
      }
    } else {
      if (items.isEmpty) {
        if (widget.loadingListBuilder != null) {
          return widget.loadingBuilderItemCount!;
        } else {
          return 1;
        }
      } else {
        return items.length + 1;
      }
    }
  }

  Widget builder(BuildContext context, int index) {
    final Widget loaderWidget = widget.loadingWidget ??
        widget.loadingListBuilder?.call(context, 0) ??
        defaultLoaderWidget;
    if (showLoadingListItems) {
      return widget.loadingListBuilder!.call(context, index);
    } else if (showLoadingItem) {
      return loaderWidget;
    } else if (showNoData) {
      return widget.noDataWidget ??
          const Center(
            child: Text('No Data to show'),
          );
    } else if (index == items.length) {
      return VisibilityDetector(
        key: UniqueKey(),
        child: loaderWidget,
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction > 0 && !isMaxLoaded && !isLoading) {
            requestPage += 1;
            fetchItems();
          }
        },
      );
    }
    return widget.builder
        .call(context, index, items[index], index == items.length);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final listWidget = ListView.builder(
      controller: controller,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      padding: widget.listPadding,
      itemCount: getListLength(),
      itemBuilder: builder,
    );
    final scrollWidget = Scrollbar(
      controller: controller,
      thickness: _scrollConfig.thickness,
      isAlwaysShown: _scrollConfig.isAlwaysShown,
      radius: _scrollConfig.radius,
      hoverThickness: _scrollConfig.hoverThickness,
      showTrackOnHover: _scrollConfig.showTrackOnHover,
      interactive: _scrollConfig.interactive,
      child: listWidget,
    );
    return RefreshIndicator(
      color: _refreshConfig.color,
      backgroundColor: _refreshConfig.backgroundColor,
      strokeWidth: _refreshConfig.strokeWidth,
      displacement: _refreshConfig.displacement,
      edgeOffset: _refreshConfig.showRefreshIndicator
          ? _refreshConfig.edgeOffset ?? 0.0
          : -150,
      triggerMode: _refreshConfig.triggerMode,
      onRefresh: () => fetchItems(isRefresh: true),
      child: _scrollConfig.useScrollBar ? scrollWidget : listWidget,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
