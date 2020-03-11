import axiosApi from './AxiosApi.js'

const apiList = {
  page: {
    method: 'POST',
    url: `/${cfg.serviceName}/${entity?uncap_first}/page`,
  },
  query: {
    method: 'POST',
    url: `/${cfg.serviceName}/${entity?uncap_first}/query`,
  },
  update: {
    method: 'PUT',
    url: `/${cfg.serviceName}/${entity?uncap_first}`
  },
  save: {
    method: 'POST',
    url: `/${cfg.serviceName}/${entity?uncap_first}`
  },
  delete: {
    method: 'DELETE',
    url: `/${cfg.serviceName}/${entity?uncap_first}`
  },
  export: {
    method: 'POST',
    url: `/${cfg.serviceName}/${entity?uncap_first}/export`
  },
  preview: {
    method: 'POST',
    url: `/${cfg.serviceName}/${entity?uncap_first}/preview`
  },
  import: {
    method: 'POST',
    url: `/${cfg.serviceName}/${entity?uncap_first}/import`
  }
}

export default {
  page (data, custom = {}) {
    return axiosApi({
      ...apiList.page,
      data,
      custom
    })
  },
  query (data, custom = {}) {
    return axiosApi({
      ...apiList.query,
      data,
      custom
    })
  },
  save (data, custom = {}) {
    return axiosApi({
      ...apiList.save,
      data,
      custom
    })
  },
  update (data, custom = {}) {
    return axiosApi({
      ...apiList.update,
      data,
      custom
    })
  },
  delete (data, custom = {}) {
    return axiosApi({
      ...apiList.delete,
      data,
      custom
    })
  },
  export (data, custom = {}) {
    return axiosApi({
      ...apiList.export,
      responseType: "blob",
      data,
      custom
    })
  },
  preview (data, custom = {}) {
    return axiosApi({
      ...apiList.preview,
      data,
      custom
    })
  },
  import (data, custom = {}) {
    return axiosApi({
      ...apiList.import,
      data,
      custom
    })
  }
}
