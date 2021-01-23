import 'ListState.dart';
import 'ListStateAction.dart';

listsReducer(ListState prevState, SetListsStateAction action) {
  final payload = action.listState;
  return prevState.copyWith(
      allLists: payload.allLists,
      errorMessage: payload.errorMessage,
      isError: payload.isError,
      isLoading: payload.isLoading,
      currentListId: payload.currentListId);
}
