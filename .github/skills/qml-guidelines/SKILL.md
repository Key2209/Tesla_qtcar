---
name: qml-guidelines
description: Guidelines and best practices for writing QML code and UI components in this project. Apply this skill when the user asks to create, modify, or review QML files.
---

# QML Guidelines for Tesla Dashboard UI

This skill defines the coding standards and best practices for our Qt/QML project. Whenever I assist you with writing or modifying QML code, I will automatically read and follow these rules.

## 1. 命名规范 (Naming Conventions)
- **文件与组件名**：QML 文件名和自定义组件必须以大写字母开头（例如：`CustomButton.qml`）。
- **属性与 ID**：使用驼峰命名法（camelCase）命名 `id`、属性（property）以及 JavaScript 变量（例如：`id: playMusicButton`）。
- **有意义的 ID**：请勿使用 `btn1`、`rect2` 等无意义的 ID，必须能够清晰表达该组件的作用。

## 2. 文件与代码结构 (Component Structure)
- **Imports 排序**：将 `import QtQuick` 等官方库放在顶部，随后是应用内的自定义目录导入。
- **模块化**：尽可能将功能独立的 UI 区域拆分到 `Components/` 目录中，避免单个 `.qml` 文件过于臃肿。
- **属性分组**：在定义对象时，优先排列 `id`，接着是自定义 property、位置与布局属性 (x, y, width, anchors)，其次是视觉属性 (color, font)，最后是信号处理函数 (onClicked等) 及其它子对象。

## 3. 样式与资源 (Styling & Assets)
- **统一配色与字体**：项目中存在 `Style.qml` 等全局配置时，请务必引用全局变量，不要在代码中硬编码颜色值（如 `color: "#FF0000"`）。
- **图标引用**：项目已将不同类型的资源分好类（`icons/`，`driving_icons/`，`network_icons/` 等），添加图标时请使用相对路径或通过 qrc 正确引用这些目录中的资源。

## 4. 交互与信号 (State & Signals)
- **声明式优先**：能用属性绑定解决的状态，请优先使用声明式数据绑定，减少命令式的 JavaScript 赋值代码。
- **私有函数**：如果需要在 QML 中编写复杂的 JavaScript 逻辑，建议封装在独立的 `.js` 文件中或使用 `QtObject` 以避免污染 QML 上下文。

---
> **提示**：你可以随时修改这个文件，添加你们团队特定的规范、C++ 和 QML 交互的习惯等。下次你让我写 QML 代码时，我就会遵守这份准则了！