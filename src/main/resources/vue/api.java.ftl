import axiosApi from './AxiosApi.js'

const apiList = {
  page: {
    method: 'GET',
    url: `/${cfg.serviceName}/${entity?uncap_first}/page`,
  },
<#if superEntityClass?? && superEntityClass=="TreeEntity">
  find: {
    method: 'GET',
    url: `/${cfg.serviceName}/${entity?uncap_first}`,
  },
</#if>
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
<#if superEntityClass?? && superEntityClass=="TreeEntity">
  find (data) {
    return axiosApi({
      ...apiList.find,
      data
    })
  },
</#if>
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
