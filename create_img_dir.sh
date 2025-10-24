#!/bin/bash

# 設定文章資料夾與圖片主資料夾
POST_DIR="_posts"
IMG_DIR="assets/img"

# 建立圖片主資料夾（如果不存在）
mkdir -p "$IMG_DIR"

# 遍歷 _posts 下的所有 md 檔
for post in "$POST_DIR"/*.md; do
    # 取得檔名，不含路徑
    filename=$(basename "$post")
    
    # 去掉副檔名 .md，保留日期
    foldername=${filename%.md}

    # 建立對應目錄
    target_dir="$IMG_DIR/$foldername"
    if [ ! -d "$target_dir" ]; then
        mkdir -p "$target_dir"
        echo "建立資料夾: $target_dir"
    else
        echo "資料夾已存在: $target_dir"
    fi
done

echo "完成所有文章資料夾建立。"

