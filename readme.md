[🇺🇸 English Version](README.en.md)

# ocrit

**ocrit** 是一个基于 Swift + Vision Framework 的命令行图像文字识别工具，支持中英文识别，支持多种输出格式，适合文本提取、批量图像处理场景。

![platform](https://img.shields.io/badge/platform-macOS-blue)
![license](https://img.shields.io/badge/license-MIT-green)
![language](https://img.shields.io/badge/language-Swift-orange)

## ✨ 功能特点

- ✅ 使用 macOS 自带 Vision 框架进行 OCR
- ✅ 支持简体中文和英文混合识别
- ✅ 支持输出为纯文本 `.txt`
- ✅ 支持输出包含坐标的 `.json`
- ✅ 支持绘制标注框图像 `.jpg`
- ✅ 提供增强模式（按坐标重排行结构）
- ✅ 支持命令行参数简写（-i, -t, -j, -d, -e）

## 🚀 快速开始

### 1. 编译

```bash
git clone https://github.com/ihugang/ocrtool.git
cd ocrtool
swift build -c release
```

### 2. 使用示例

```bash
.build/release/ocrtool \
  --input test.jpg \
  --txt result.txt \
  --json result.json \
  --draw marked.jpg \
  --enhanced
```

或使用简写参数：

```bash
.build/release/ocrtool \
  -i test.jpg \
  -t result.txt \
  -j result.json \
  -d marked.jpg \
  -e
```

## 🧩 参数说明

| 参数        | 简写 | 说明 |
|-------------|------|------|
| `--input`   | `-i` | 输入图片路径（必选） |
| `--txt`     | `-t` | 输出文本文件路径（按行） |
| `--json`    | `-j` | 输出 JSON 文件（包含文字及坐标） |
| `--draw`    | `-d` | 输出绘制标注框的图片 |
| `--enhanced`| `-e` | 启用增强模式（按坐标合并行，适合截图 OCR） |

## 📦 输出样例

### 纯文本输出（增强模式）

```
Hello world from image
This is a second line
```

### JSON 输出格式（像素坐标）

```json
[
  {
    "text": "Hello",
    "boundingBox": { "x": 48, "y": 92, "width": 120, "height": 20 }
  },
  ...
]
```

### 标注图示例（`marked.jpg`）

> 图片中自动绘制红色识别框，便于校对 OCR 准确率。

## 👨‍💻 作者信息

- 作者：Hu Gang ([@ihugang](https://github.com/ihugang))
- 邮箱：ihugang@gmail.com

---

## 📝 License

MIT License
