package com.github.zuihoou.generator.ext;

import java.io.File;

import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.generator.config.ConstVal;
import com.baomidou.mybatisplus.generator.config.FileOutConfig;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.github.zuihoou.generator.CodeGenerator;
import com.github.zuihoou.generator.config.CodeGeneratorConfig;
import com.github.zuihoou.generator.config.FileCreateConfig;
import com.github.zuihoou.generator.type.GenerateType;

/**
 * This is a Description
 *
 * @author zuihou
 * @date 2019/05/26
 */
public class FileOutConfigExt extends FileOutConfig {

    String innerBasePath;

    String projectSuffix;
    String modularSuffix;
    GenerateType generateType;
    CodeGeneratorConfig config;

    public FileOutConfigExt(String innerBasePath, String modularSuffix, CodeGeneratorConfig config) {
        this.innerBasePath = innerBasePath;
        this.modularSuffix = modularSuffix;
        this.config = config;
        FileCreateConfig fileCreateConfig = config.getFileCreateConfig();
        switch (modularSuffix) {
            case CodeGenerator.ENUM_PATH:
                this.setTemplatePath("/templates/enum.java.ftl");
                this.projectSuffix = config.getEntitySuffix();
                this.generateType = fileCreateConfig.getGenerateEnum();
                break;
//            case CodeGenerator.DTO_PATH:
//                this.setTemplatePath("/templates/dto.java.ftl");
//                this.projectSuffix = config.getEntitySuffix();
//                this.generateType = fileCreateConfig.getGenerateDto();
//                break;
            case CodeGenerator.SAVE_DTO_PATH:
                this.setTemplatePath("/templates/saveDto.java.ftl");
                this.projectSuffix = config.getEntitySuffix();
                this.generateType = fileCreateConfig.getGenerateDto();
                break;
            case CodeGenerator.UPDATE_DTO_PATH:
                this.setTemplatePath("/templates/updateDto.java.ftl");
                this.projectSuffix = config.getEntitySuffix();
                this.generateType = fileCreateConfig.getGenerateDto();
                break;
            case CodeGenerator.CONSTANT_PATH:
                this.setTemplatePath("/templates/constant.java.ftl");
                this.projectSuffix = config.getEntitySuffix();
                this.generateType = fileCreateConfig.getGenerateConstant();
                break;
            case CodeGenerator.QUERY_PATH:
                this.setTemplatePath("/templates/query.java.ftl");
                this.projectSuffix = config.getEntitySuffix();
                this.generateType = fileCreateConfig.getGenerateQuery();
                break;
            case ConstVal.ENTITY:
                this.setTemplatePath(ConstVal.TEMPLATE_ENTITY_JAVA + ".ftl");
                this.projectSuffix = config.getEntitySuffix();
                this.generateType = fileCreateConfig.getGenerateEntity();
                break;
            case ConstVal.SERVICE:
                this.setTemplatePath(ConstVal.TEMPLATE_SERVICE + ".ftl");
                this.projectSuffix = config.getServiceSuffix();
                this.generateType = fileCreateConfig.getGenerateService();
                break;
            case ConstVal.SERVICE_IMPL:
                this.setTemplatePath(ConstVal.TEMPLATE_SERVICE_IMPL + ".ftl");
                this.projectSuffix = config.getServiceSuffix();
                this.generateType = fileCreateConfig.getGenerateServiceImpl();
                break;
            case ConstVal.MAPPER:
                this.setTemplatePath(ConstVal.TEMPLATE_MAPPER + ".ftl");
                this.projectSuffix = config.getServiceSuffix();
                this.generateType = fileCreateConfig.getGenerateDao();
                break;
            case ConstVal.XML:
                this.setTemplatePath(ConstVal.TEMPLATE_XML + ".ftl");
                this.projectSuffix = config.getServiceSuffix();
                this.generateType = fileCreateConfig.getGenerateXml();
                break;
            case ConstVal.CONTROLLER:
                this.setTemplatePath(ConstVal.TEMPLATE_CONTROLLER + ".ftl");
                this.projectSuffix = config.getControllerSuffix();
                this.generateType = fileCreateConfig.getGenerateController();
                break;
            case CodeGenerator.API_PATH:
                this.setTemplatePath("/templates/api.java.ftl");
                this.projectSuffix = config.getApiSuffix();
                this.generateType = fileCreateConfig.getGenerateApi();
                break;
            default:
                break;
        }
    }

    @Override
    public String outputFile(TableInfo tableInfo) {
        if (ConstVal.XML.equals(modularSuffix)) {
            String projectRootPath = config.getProjectRootPath();
            if (!projectRootPath.endsWith(File.separator)) {
                projectRootPath += File.separator;
            }

            StringBuilder basePathSb = new StringBuilder(projectRootPath);
            if (config.isEnableMicroService()) {
                basePathSb.append(config.getProjectPrefix());
                basePathSb.append(config.getChildModuleName());
                basePathSb.append(projectSuffix)
                        .append(File.separator);
            }
            basePathSb.append(CodeGenerator.SRC_MAIN_RESOURCE)
                    .append(File.separator)
                    .append("mapper_")
                    .append(config.getChildModuleName())
                    .append(File.separator)
                    .append("base");
            if (StringUtils.isNotEmpty(config.getChildPackageName())) {
                basePathSb.append(File.separator).append(config.getChildPackageName());
            }

            //basePath = basePath + File.separator + tableInfo.getEntityName() + modularSuffix + StringPool.DOT_JAVA;
            basePathSb.append(File.separator)
                    .append(tableInfo.getEntityName())
                    .append("Mapper")
                    .append(StringPool.DOT_XML);

            if (GenerateType.ADD.eq(generateType) && FileCreateConfig.isExists(basePathSb.toString())) {
                basePathSb.append(".new");
            }
            return basePathSb.toString();
        }

        // 根路径 + 项目名 + SRC_MAIN_JAVA + 基础包 + service + 子模块 + EntityName+后缀

        String projectName = "";
        if (config.isEnableMicroService()) {
            if (CodeGenerator.ENUM_PATH.equals(modularSuffix)
                    || CodeGenerator.SAVE_DTO_PATH.equals(modularSuffix)
                    || CodeGenerator.UPDATE_DTO_PATH.equals(modularSuffix)
                    || CodeGenerator.CONSTANT_PATH.equals(modularSuffix)
                    || CodeGenerator.QUERY_PATH.equals(modularSuffix)
                    || ConstVal.ENTITY.equals(modularSuffix)) {
                projectName = config.getProjectPrefix() + config.getServiceName() + projectSuffix + File.separator;
            } else {
                projectName = config.getProjectPrefix() + config.getChildModuleName() + projectSuffix + File.separator;
            }
        }
        String basePath = String.format(innerBasePath, projectName);

        String innerModularSuffix = modularSuffix;
        if (ConstVal.SERVICE_IMPL.equals(innerModularSuffix)) {
            innerModularSuffix = "service";
        } else if (CodeGenerator.SAVE_DTO_PATH.equals(innerModularSuffix)) {
            innerModularSuffix = "dto";
        } else if (CodeGenerator.UPDATE_DTO_PATH.equals(innerModularSuffix)) {
            innerModularSuffix = "dto";
        } else if (ConstVal.MAPPER.equals(innerModularSuffix)) {
            innerModularSuffix = "dao";
        } else {
            innerModularSuffix = StringUtils.firstCharToLower(modularSuffix);
        }

        basePath = basePath + File.separator + innerModularSuffix;
        if (StringUtils.isNotEmpty(config.getChildPackageName())) {
            basePath = basePath + File.separator + config.getChildPackageName();
        }
        if (ConstVal.SERVICE_IMPL.equals(modularSuffix)) {
            basePath = basePath + File.separator + "impl";
        }

        if (ConstVal.ENTITY.equals(modularSuffix)) {
            basePath = basePath + File.separator + tableInfo.getEntityName() + StringPool.DOT_JAVA;
        } else if (ConstVal.XML.equals(modularSuffix)) {
            basePath = basePath + File.separator + tableInfo.getEntityName() + "Mapper" + StringPool.DOT_JAVA;
        } else if (CodeGenerator.QUERY_PATH.equals(modularSuffix)) {
            basePath = basePath + File.separator + tableInfo.getEntityName() + "Wrapper" + StringPool.DOT_JAVA;
        } else {
            basePath = basePath + File.separator + tableInfo.getEntityName() + modularSuffix + StringPool.DOT_JAVA;
        }

        if (GenerateType.ADD.eq(generateType) && FileCreateConfig.isExists(basePath)) {
            basePath += ".new";
        }
        return basePath;
    }
}
