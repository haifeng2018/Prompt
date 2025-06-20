import HashMap from '@ohos.util.HashMap';
import Logger from 'lib_core_model/src/main/ets/util/Logger';
// import { AliPlayer, AliPlayerFactory } from '../../../../oh_modules/premierlibrary';
// import { AliPlayer, AliPlayerFactory } from 'premierlibrary';

export class AliVideoController {
  tag: string = 'VideoController'
  // private playerMap: HashMap<number, AliPlayer> = new HashMap();
  private index: number = 0;

  /**
   * 创建播放器时会返回唯一id， 用于向 VideoController 索引 AliPlayer
   * @param context
   * @param traceId
   * @returns
   */
  public createAliPlayer(context: Context, traceId: string | null) {
    // let playerInstance = AliPlayerFactory.createAliPlayer(context, traceId || '');
    // this.playerMap.set(this.index, playerInstance);
    // Logger.info(this.tag, `created: index = ${this.index}, playerInstance = ${playerInstance}`);
    return this.index++;
  }

  /*public getPlayer(index: number): AliPlayer | undefined {
    if (index === -1) {
      return;
    }
    if (this.playerMap.hasKey(index)) {
      return this.playerMap.get(index);
    }
    return;
  }*/

  public dispose(index: number) {
   /* if (this.playerMap.hasKey(index)) {
      this.playerMap.get(index).release();
      this.playerMap.remove((index));
    }*/
  }
}

export default new AliVideoController();

