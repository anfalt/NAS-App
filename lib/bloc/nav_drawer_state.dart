// this is the state the user is expected to see
class NavDrawerState {
  final NavItem selectedItem;
  final Map<String, String> arguments;
  const NavDrawerState(this.selectedItem, [this.arguments]);
}

// helpful navigation pages, you can change
// them to support your pages
enum NavItem { homePage, imagePage, calendarPage }
