/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: GlobalContext
 * Author: Victor
 * Date: 2024/05/21 12:10
 * Description: 
 * -----------------------------------------------------------------
 */

export class GlobalContext {
 private constructor() { }
 private static instance: GlobalContext;
 private _objects = new Map<string, Object>();

 public static getContext(): GlobalContext {
  if (!GlobalContext.instance) {
   GlobalContext.instance = new GlobalContext();
  }
  return GlobalContext.instance;
 }

 getObject(value: string): Object | undefined {
  return this._objects.get(value);
 }

 setObject(key: string, objectClass: Object): void {
  this._objects.set(key, objectClass);
 }
}