/**
 * 轮播图数据模型
 *
 * @param id id
 * @param name 标题
 * @param image 图片
 */
export class SplashInfo{
  id: string;
  name: string;
  image: Resource;

  constructor(id: string, name: string, image: Resource) {
    this.id = id;
    this.name = name;
    this.image = image;
  }
}
