# Change: Refactor to Standard R Package

## Why
当前项目是一个独立的 Shiny 应用，代码组织松散，缺乏标准化的依赖管理、文档和测试基础设施。重构为标准 R 包将带来：
- 更好的代码组织和可维护性
- 标准化的依赖声明和版本管理
- 内置的文档系统 (roxygen2)
- 可测试的函数结构
- 便于分享和安装

## What Changes
- **BREAKING**: 项目结构完全重组为 R 包标准布局
- 添加 `DESCRIPTION` 文件声明包元数据和依赖
- 添加 `NAMESPACE` 文件管理导出函数
- 将 `R/` 中的函数添加 roxygen2 文档
- Shiny 应用移至 `inst/app/` 目录
- 静态资源 (CSS, JS, 图片) 移至 `inst/` 子目录
- 添加 `tests/` 目录支持单元测试
- 添加启动函数 `run_app()` 用于启动应用

## Impact
- Affected specs: package-structure (new capability)
- Affected code: 
  - `app.R` → `inst/app/app.R`
  - `R/*.R` → `R/*.R` (添加文档)
  - `www/`, `chat/`, `styles.css` → `inst/`
  - 新增 `DESCRIPTION`, `NAMESPACE`, `man/`
