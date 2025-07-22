#!/bin/bash

# ZDBleTool 部署检查脚本
# 用于验证项目配置是否正确

echo "🔍 开始检查 ZDBleTool 项目配置..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查函数
check_file_exists() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅ $1 存在${NC}"
        return 0
    else
        echo -e "${RED}❌ $1 不存在${NC}"
        return 1
    fi
}

check_directory_exists() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✅ $1 目录存在${NC}"
        return 0
    else
        echo -e "${RED}❌ $1 目录不存在${NC}"
        return 1
    fi
}

# 检查必要文件
echo -e "\n📁 检查项目文件结构..."
check_file_exists "ZDBleTool.podspec"
check_file_exists "README.md"
check_file_exists "LICENSE"
check_file_exists "ZDBleTool/ZDBleTool.h"
check_file_exists "ZDBleTool/Tools/ZDBleManagerTool.h"
check_file_exists "ZDBleTool/Tools/ZDBleDataModelTool.h"
check_file_exists "ZDBleTool/Category/NSString+zdTool.h"
check_file_exists "ZDBleTool/Category/NSData+zdTool.h"
check_file_exists "ZDBleTool/Category/NSObject+zdTool.h"

# 检查实现文件
echo -e "\n🔧 检查实现文件..."
check_file_exists "ZDBleTool/Tools/ZDBleManagerTool.m"
check_file_exists "ZDBleTool/Tools/ZDBleDataModelTool.m"
check_file_exists "ZDBleTool/Category/NSString+zdTool.m"
check_file_exists "ZDBleTool/Category/NSData+zdTool.m"
check_file_exists "ZDBleTool/Category/NSObject+zdTool.m"

# 检查测试文件
echo -e "\n🧪 检查测试文件..."
check_file_exists "ZDBleToolTests/ZDBleToolTests.m"

# 检查 Xcode 项目
echo -e "\n📱 检查 Xcode 项目..."
check_file_exists "ZDBleTool.xcodeproj/project.pbxproj"

# 检查 podspec 配置
echo -e "\n📦 检查 Podspec 配置..."
if [ -f "ZDBleTool.podspec" ]; then
    # 检查是否包含所有源文件
    if grep -q "ZDBleTool/\*\*/\*\.{h,m}" ZDBleTool.podspec; then
        echo -e "${GREEN}✅ Podspec 包含所有源文件${NC}"
    else
        echo -e "${RED}❌ Podspec 源文件配置可能不完整${NC}"
    fi
    
    # 检查是否包含框架依赖
    if grep -q "CoreBluetooth" ZDBleTool.podspec; then
        echo -e "${GREEN}✅ Podspec 包含 CoreBluetooth 框架${NC}"
    else
        echo -e "${RED}❌ Podspec 缺少 CoreBluetooth 框架依赖${NC}"
    fi
    
    # 检查权限声明
    if grep -q "NSBluetoothAlwaysUsageDescription" ZDBleTool.podspec; then
        echo -e "${GREEN}✅ Podspec 包含蓝牙权限声明${NC}"
    else
        echo -e "${YELLOW}⚠️  Podspec 缺少蓝牙权限声明${NC}"
    fi
fi

# 检查 README 内容
echo -e "\n📖 检查 README 内容..."
if [ -f "README.md" ]; then
    if grep -q "## 使用示例" README.md; then
        echo -e "${GREEN}✅ README 包含使用示例${NC}"
    else
        echo -e "${YELLOW}⚠️  README 缺少使用示例${NC}"
    fi
    
    if grep -q "## 安装" README.md; then
        echo -e "${GREEN}✅ README 包含安装说明${NC}"
    else
        echo -e "${YELLOW}⚠️  README 缺少安装说明${NC}"
    fi
fi

# 检查主头文件导入
echo -e "\n📋 检查头文件导入..."
if [ -f "ZDBleTool/ZDBleTool.h" ]; then
    if grep -q "NSString+zdTool.h" ZDBleTool/ZDBleTool.h; then
        echo -e "${GREEN}✅ 主头文件包含 NSString 分类${NC}"
    else
        echo -e "${RED}❌ 主头文件缺少 NSString 分类导入${NC}"
    fi
    
    if grep -q "ZDBleManagerTool.h" ZDBleTool/ZDBleTool.h; then
        echo -e "${GREEN}✅ 主头文件包含蓝牙管理器${NC}"
    else
        echo -e "${RED}❌ 主头文件缺少蓝牙管理器导入${NC}"
    fi
fi

# 检查 CocoaPods 验证
echo -e "\n🔍 检查 CocoaPods 配置..."
if command -v pod &> /dev/null; then
    echo -e "${GREEN}✅ CocoaPods 已安装${NC}"
    
    # 尝试验证 podspec（不实际发布）
    echo -e "${YELLOW}⚠️  运行 pod lib lint 验证...${NC}"
    if pod lib lint ZDBleTool.podspec --allow-warnings --skip-import-validation 2>/dev/null; then
        echo -e "${GREEN}✅ Podspec 验证通过${NC}"
    else
        echo -e "${RED}❌ Podspec 验证失败，请检查配置${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  CocoaPods 未安装，跳过验证${NC}"
fi

# 检查 Git 配置
echo -e "\n📝 检查 Git 配置..."
if [ -d ".git" ]; then
    echo -e "${GREEN}✅ Git 仓库已初始化${NC}"
    
    # 检查是否有远程仓库
    if git remote -v | grep -q "origin"; then
        echo -e "${GREEN}✅ 已配置远程仓库${NC}"
    else
        echo -e "${YELLOW}⚠️  未配置远程仓库${NC}"
    fi
    
    # 检查是否有标签
    if git tag | grep -q "0.1.0"; then
        echo -e "${GREEN}✅ 已创建版本标签 0.1.0${NC}"
    else
        echo -e "${YELLOW}⚠️  未创建版本标签，建议创建标签：git tag 0.1.0${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Git 仓库未初始化${NC}"
fi

echo -e "\n🎉 检查完成！"
echo -e "\n📋 部署建议："
echo -e "1. 确保所有文件都存在且配置正确"
echo -e "2. 运行 'pod lib lint' 验证 podspec"
echo -e "3. 创建 Git 标签：git tag 0.1.0"
echo -e "4. 推送到远程仓库：git push origin 0.1.0"
echo -e "5. 在目标项目中测试集成"

echo -e "\n💡 如果发现问题，请根据上述提示进行修复。" 