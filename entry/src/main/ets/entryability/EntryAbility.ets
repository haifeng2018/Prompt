import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
import { BusinessError } from '@kit.BasicServicesKit';
import RouterPath from 'lib_core_model/src/main/ets/util/RouterPath';
import { GlobalContext } from '../util/GlobalContext';
import { WindowUtil } from '../util/WindowUtil';
import { AppStorageConstants } from '../data/AppStorageConstants';

export default class EntryAbility extends UIAbility {
  readonly TAG: string = 'EntryAbility'

  entryPage: string = RouterPath.SPLASH_PAGE;
  // entryPage: string = RouterPath.MAIN_PAGE;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    GlobalContext.getContext().setObject('abilityWant', want)
    GlobalContext.getContext().setObject('context', this.context)
    if (want.parameters) {
      if (want.parameters.currentTime) {
        GlobalContext.getContext().setObject('currentTime', want.parameters.currentTime);
        console.info(this.TAG, 'time: ' + want.parameters.currentTime);
      }
    }
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    try {
      windowStage.on('windowStageEvent', (data) => {
        let stageEventType: window.WindowStageEventType = data;
        switch (stageEventType) {
          case window.WindowStageEventType.SHOWN: // 切到前台
            Logger.error(this.TAG,'windowStage foreground.');
            break;
          case window.WindowStageEventType.ACTIVE: // 获焦状态
            Logger.error(this.TAG,'windowStage active.');
            break;
          case window.WindowStageEventType.INACTIVE: // 失焦状态
            Logger.error(this.TAG,'windowStage inactive.');
            break;
          case window.WindowStageEventType.HIDDEN: // 切到后台
            Logger.error(this.TAG,'windowStage background.');
            break;
          default:
            break;
        }
      });
    } catch (exception) {
      Logger.error('Failed to enable the listener for window stage event changes. Cause:' + JSON.stringify(exception));
    }

    let windowUtil: WindowUtil | undefined = WindowUtil.getInstance();
    if (windowUtil !== undefined) {
      windowUtil.setWindowStage(windowStage);
      windowUtil.setMainWindowPortrait();
    }

    windowStage.loadContent(this.entryPage, (err) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }

      let windowClass: window.Window = windowStage.getMainWindowSync(); // 获取应用主窗口
      // 1. 设置窗口全屏
      let isLayoutFullScreen = true;
      windowClass.setWindowLayoutFullScreen(isLayoutFullScreen)
        .then(() => {
          console.info('Succeeded in setting the window layout to full-screen mode.');
        })
        .catch((err: BusinessError) => {
          console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
        });

      // 2. 获取布局避让遮挡的区域
      let type = window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR; // 以导航条避让为例
      let avoidArea = windowClass.getWindowAvoidArea(type);
      let bottomRectHeight = avoidArea.bottomRect.height; // 获取到导航条区域的高度
      AppStorage.setOrCreate(AppStorageConstants.NAVIGATION_INDICATOR_HEIGHT_KEY, bottomRectHeight);

      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');

    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
