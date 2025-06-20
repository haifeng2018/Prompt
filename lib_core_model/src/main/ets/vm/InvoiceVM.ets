import http from '@ohos.net.http'
import { InvoiceApi } from '../api/InvoiceApi'
import { InvoiceCompanyInfo } from '../data/InvoiceCompanyInfo'
import { InvoicePageInfo } from '../data/InvoicePageInfo'
import { ListData } from '../data/ListData'
import { MakeOutInvoiceParm } from '../data/MakeOutInvoiceParm'
import { OrderDetailData } from '../data/OrderDetailData'
import { OrderInvoiceData } from '../data/OrderInvoiceData'
import { SendInvoiceParm } from '../data/SendInvoiceParm'
import HttpCore from '../module/HttpCore'
import Request from '../module/Request'
import { Response } from '../module/Response'
import Logger from '../util/Logger'

export default class InvoiceVM {

  public static sendInvoicePageRequest(token: string, pageIndex: number, pageSize: number,
    status: number): Promise<Array<InvoicePageInfo>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendInvoicePageRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = InvoiceApi.INVOICE_PAGE
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'], [token])
      if (status >= 0) {
        request.setQueryParams(['pageIndex', 'pageSize', 'status'], [`${pageIndex}`, `${pageSize}`, `${status}`])
      } else {
        request.setQueryParams(['pageIndex', 'pageSize'], [`${pageIndex}`, `${pageSize}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: ListData<InvoicePageInfo> = JSON.parse(json)
            resolve(data.records)
          } else {
            resolve([])
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendSyncSignInvoiceRequest(tenantId: number,token: string,
    orderNo: string): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSyncSignInvoiceRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = InvoiceApi.SYNC_SIGN_INVOICE
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'], [token])
      request.setQueryParams(['orderNo', 'tenantId'], [orderNo, `${tenantId}`])

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: object = JSON.parse(json)
            resolve(data)
          } else {
            resolve(null)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendOrderInvoiceRequest(tenantId: number,token: string,
    orderNo: string): Promise<OrderInvoiceData> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSyncSignInvoiceRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = InvoiceApi.ORDER_INVOICE
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'], [token])
      request.setQueryParams(['orderNo'], [orderNo])

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: OrderInvoiceData = JSON.parse(json)
            resolve(data)
          } else {
            resolve(null)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendInvoiceStatusRequest(tenantId: number,token: string,
    orderNo: string): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSyncSignInvoiceRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = InvoiceApi.INVOICE_STATUS
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'], [token])
      request.setQueryParams(['orderNo'], [orderNo])

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: object = JSON.parse(json)
            resolve(data)
          } else {
            resolve(null)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendInvoiceCompanyRequest(tenantId: number,token: string,
    keyword: string): Promise<Array<InvoiceCompanyInfo>> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSyncSignInvoiceRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = InvoiceApi.INVOICE_COMPANY
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'], [token])
      request.setQueryParams(['keyword'], [keyword])

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: Array<InvoiceCompanyInfo> = JSON.parse(json)
            resolve(data)
          } else {
            resolve([])
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendMakeOutInvoiceRequest(tenantId: number,token: string,
    body: MakeOutInvoiceParm): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSyncSignInvoiceRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = InvoiceApi.MAKE_OUT_INVOICE
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'], [token])
      request.setBody(body)

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: object = JSON.parse(json)
            resolve(data)
          } else {
            resolve(null)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendSendInvoiceRequest(tenantId: number,token: string,
    body: SendInvoiceParm): Promise<object> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSyncSignInvoiceRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = InvoiceApi.SEND_INVOICE
      request.method = http.RequestMethod.POST
      request.addHeader(['AccessToken'], [token])
      request.setBody(body)

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: object = JSON.parse(json)
            resolve(data)
          } else {
            resolve(null)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

  public static sendInvoiceOrderDetailRequest(tenantId: number,token: string,
    orderNo: string): Promise<OrderDetailData> {

    return new Promise(async (resolve: Function, reject: Function) => {
      if (!token) {
        Logger.error('sendSyncSignInvoiceRequest-token is empty')
        return
      }
      let request = new Request()
      request.url = InvoiceApi.INVOICE_ORDER_DETAIL
      request.method = http.RequestMethod.GET
      request.addHeader(['AccessToken'], [token])
      request.setQueryParams(['orderNo'],[orderNo])

      if (tenantId > 0) {
        request.addHeader(['Tenant-Id'],[`${tenantId}`])
      }

      HttpCore.send(request).then((response: Response) => {
        if (response.code === 1) {
          if (response.data) {
            let json = JSON.stringify(response.data)
            let data: OrderDetailData = JSON.parse(json)
            resolve(data)
          } else {
            resolve(null)
          }
        } else {
          reject(response.message)
        }
      }).catch(() => {
        reject('服务器开小差了,请稍后重试!')
      });
    })
  }

}