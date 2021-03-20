import 'package:meta/meta.dart';
import 'package:nas_app/Model/List.dart';

@immutable
class ListState {
  final bool? isError;
  final String? errorMessage;
  final bool? isLoading;
  final List<ListElement>? allLists;
  final String? currentListId;

  ListState(
      {this.isError,
      this.isLoading,
      this.allLists,
      this.errorMessage,
      this.currentListId});

  factory ListState.initial() => ListState(
      isLoading: false,
      isError: false,
      errorMessage: "",
      allLists: null,
      currentListId: null);

  ListState copyWith({
    required bool? isError,
    required String? errorMessage,
    required bool? isLoading,
    required List<ListElement>? allLists,
    required String? currentListId,
  }) {
    return ListState(
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
        isLoading: isLoading ?? this.isLoading,
        allLists: allLists ?? this.allLists,
        currentListId: currentListId ?? this.currentListId);
  }
}
