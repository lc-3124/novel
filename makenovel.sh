#!

# 小说名称
NOVEL_NAME="魔女的日常"
# 输出目录
OUTPUT_DIR="build"
# 作者序路径
AUTHOR="作者序.txt"

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 检查作者序是否存在
if [ ! -f "$AUTHOR" ]; then
  echo "错误：未找到 $AUTHOR 文件"
  exit 1
fi

# 循环处理所有卷次目录（src/第*卷）
for vol_dir in src/第*卷; do
  # 提取卷次编号（如从"src/第1卷"中提取"1"）
  vol_num=$(echo "$vol_dir" | grep -oP '第\K\d+')
  if [ -z "$vol_num" ]; then
    echo "跳过非标准卷次目录：$vol_dir"
    continue
  fi

  # 输出文件名
  output_file="$OUTPUT_DIR/${NOVEL_NAME}-第${vol_num}卷.txt"

  # 获取当前卷下的所有txt文件，按数字排序（如0.txt→1.txt→2.txt）
  chapters=$(find "$vol_dir" -maxdepth 1 -type f -name "*.txt" | sort -V)

  if [ -z "$chapters" ]; then
    echo "警告：$vol_dir 目录下没有找到txt文件，跳过"
    continue
  fi

  # 先写入作者序，再拼接排序后的章节
  echo "正在合并：$vol_dir → $output_file"
  cat "$AUTHOR" $chapters > "$output_file"
done

echo "所有卷次合并完成，输出文件在 $OUTPUT_DIR 目录下"

