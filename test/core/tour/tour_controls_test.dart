import 'package:alquranalkareem/core/tour/tour_controls.dart';
import 'package:flutter_test/flutter_test.dart';

/// يسجّل ما طلبه الصنف من التطبيق بدل وحدات التحكم الحقيقية.
class _FakeHooks implements TourControlsHooks {
  @override
  bool isControlsVisible = false;

  int toggles = 0;
  int collapses = 0;

  @override
  void toggleControls() {
    toggles++;
    isControlsVisible = !isControlsVisible;
  }

  @override
  void collapsePanels() => collapses++;
}

void main() {
  late _FakeHooks hooks;
  late TourControlsSync sync;

  setUp(() {
    hooks = _FakeHooks();
    sync = TourControlsSync(hooks);
  });

  test('showing the bars reveals hidden ones and folds the panels', () {
    sync.sync(visible: true);
    expect(hooks.isControlsVisible, isTrue);
    expect(hooks.toggles, 1);
    expect(hooks.collapses, 1);
  });

  test('asking again keeps the bars shown and folds the panels each time', () {
    // One of the panels may have been reopened: it is folded again.
    sync.sync(visible: true);
    sync.sync(visible: true);
    expect(hooks.toggles, 1);
    expect(hooks.collapses, 2);
  });

  test('hiding the bars leaves the panels alone', () {
    hooks.isControlsVisible = true;
    sync.sync(visible: false);
    expect(hooks.isControlsVisible, isFalse);
    expect(hooks.collapses, 0);
  });

  test("null returns the bars to the user's hidden ones", () {
    sync.sync(visible: true);
    sync.sync(visible: null);
    expect(hooks.isControlsVisible, isFalse);
    expect(hooks.toggles, 2);
  });

  test('the bars the user already shows are left alone', () {
    hooks.isControlsVisible = true;
    sync.sync(visible: true);
    sync.sync(visible: null);
    expect(hooks.toggles, 0);
    expect(hooks.isControlsVisible, isTrue);
  });

  test('nothing is restored before the tour has taken the bars', () {
    sync.sync(visible: null);
    sync.restore();
    expect(hooks.toggles, 0);
  });

  test('the bars are taken again from wherever the user left them', () {
    sync.sync(visible: true);
    sync.restore();
    expect(hooks.isControlsVisible, isFalse);

    // The user shows them, then a later stop needs them hidden.
    hooks.isControlsVisible = true;
    sync.sync(visible: false);
    expect(hooks.toggles, 3);
    sync.restore();
    expect(hooks.isControlsVisible, isTrue);
    expect(hooks.toggles, 4);
  });
}
