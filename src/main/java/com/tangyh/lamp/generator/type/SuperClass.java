package com.tangyh.lamp.generator.type;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public enum SuperClass {

    SUPER_CLASS("com.tangyh.basic.base.controller.SuperController", "com.tangyh.basic.base.service.SuperService",
            "com.tangyh.basic.base.service.SuperServiceImpl", "com.tangyh.basic.base.mapper.SuperMapper"),
    SUPER_CACHE_CLASS("com.tangyh.basic.base.controller.SuperCacheController", "com.tangyh.basic.base.service.SuperCacheService",
            "com.tangyh.basic.base.service.SuperCacheServiceImpl", "com.tangyh.basic.base.mapper.SuperMapper"),
    NONE("", "", "", "");

    private String controller;
    private String service;
    private String serviceImpl;
    private String mapper;

    public SuperClass setController(String controller) {
        this.controller = controller;
        return this;
    }

    public SuperClass setService(String service) {
        this.service = service;
        return this;
    }

    public SuperClass setMapper(String mapper) {
        this.mapper = mapper;
        return this;
    }

    public SuperClass setServiceImpl(String serviceImpl) {
        this.serviceImpl = serviceImpl;
        return this;
    }
}
