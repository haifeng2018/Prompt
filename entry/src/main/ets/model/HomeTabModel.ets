/*
 * -----------------------------------------------------------------
 * Copyright (C) 2018-2028, by Victor, All rights reserved.
 * -----------------------------------------------------------------
 * File: HomeTabModel
 * Author: Victor
 * Date: 2023/2/27 14:53
 * Description: 
 * -----------------------------------------------------------------
 */

export interface NavItem {
  icon: Resource;
  icon_selected: Resource;
  text: Resource;
  id: number;
}

export enum TabId {
  HOME,
  TUTORIAL,
  TOOLS,
  ME
}

export enum OrganTabId {
  HOME,
  CATEGORY,
  STUDY_CENTER
}

export const NavList: NavItem[] = [
  {
    icon: $r('app.media.ic_home_normal'),
    icon_selected: $r('app.media.ic_home_checked'),
    text: $r('app.string.tab_home'),
    id: TabId.HOME
  },
  {
    icon: $r('app.media.ic_course_normal'),
    icon_selected: $r('app.media.ic_course_checked'),
    text: $r('app.string.tab_tutorial'),
    id: TabId.TUTORIAL
  },
  {
    icon: $r('app.media.ic_study_center_normal'),
    icon_selected: $r('app.media.ic_study_center_checked'),
    text: $r('app.string.tab_tools'),
    id: TabId.TOOLS
  },
  {
    icon: $r('app.media.ic_me_normal'),
    icon_selected: $r('app.media.ic_me_checked'),
    text: $r('app.string.tab_me'),
    id: TabId.ME
  }
]

export const OrganNavList: NavItem[] = [
  {
    icon: $r('app.media.ic_home_normal'),
    icon_selected: $r('app.media.ic_home_checked'),
    text: $r('app.string.tab_home'),
    id: OrganTabId.HOME
  },
  {
    icon: $r('app.media.ic_course_normal'),
    icon_selected: $r('app.media.ic_course_checked'),
    text: $r('app.string.tab_category'),
    id: OrganTabId.CATEGORY
  },
  {
    icon: $r('app.media.ic_study_center_normal'),
    icon_selected: $r('app.media.ic_study_center_checked'),
    text: $r('app.string.tab_study_center'),
    id: OrganTabId.STUDY_CENTER
  }
]