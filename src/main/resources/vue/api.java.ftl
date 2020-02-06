import axiosApi from './AxiosApi.js'

const apiList = {
  page: {
    method: 'GET',
    url: `/${cfg.serviceName}/${entity?uncap_first}/page`,
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
  }
}

export default {
  page (data) {
    return axiosApi({
      ...apiList.page,
      data
    })
  },
  save (data) {
    return axiosApi({
      ...apiList.save,
      data
    })
  },
  update (data) {
    return axiosApi({
      ...apiList.update,
      data
    })
  },
  delete (data) {
    return axiosApi({
      ...apiList.delete,
      data
    })
  }
}
