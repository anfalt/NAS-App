// import 'package:bloc/bloc.dart';
// import 'package:flutter/foundation.dart';

// import './nav_drawer_event.dart';
// import './nav_drawer_state.dart';

// class NavDrawerBloc extends Bloc<NavDrawerEvent, NavDrawerState> {
// // You can also have an optional constructor here that takes
//   // a repository that you can use later to make network requests
// // this is the initial state the user will see when
//   // the bloc is first created
//   @override
//   NavDrawerState get initialState => NavDrawerState(NavItem.homePage);
//   @override
//   Stream<NavDrawerState> mapEventToState(NavDrawerEvent event) async* {
//     // this is where the events are handled, if you want to call a method
//     // you can yield* instead of the yield, but make sure your
//     // method signature returns Stream<NavDrawerState> and is async*
//     if (event is NavigateTo) {
//       // only route to a new location if the new location is different
//       if (event.destination != state.selectedItem ||
//           !mapEquals(event.arguments, state.arguments)) {
//         yield NavDrawerState(event.destination, event.arguments);
//       }
//     }
//   }
// }
