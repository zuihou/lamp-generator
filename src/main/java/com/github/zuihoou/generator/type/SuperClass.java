package com.github.zuihoou.generator.type;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public enum SuperClass {

    SUPER_CLASS("com.github.zuihou.base.controller.SuperController", "com.github.zuihou.base.service.SuperService",
            "com.github.zuihou.base.service.SuperServiceImpl", "com.github.zuihou.base.mapper.SuperMapper"),
    SUPER_CACHE_CLASS("com.github.zuihou.base.controller.SuperCacheController", "com.github.zuihou.base.service.SuperCacheService",
            "com.github.zuihou.base.service.SuperCacheServiceImpl", "com.github.zuihou.base.mapper.SuperMapper"),
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
