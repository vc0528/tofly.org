---
title: "列出Proxmox VE cluster 全部vm"
date: 2025-10-28 20:15:00 +0800
categories: [資訊, Proxmox]
tags: [虛擬化, proxmox]
---

### 有時需要查詢虛擬機的狀態, 尤其在只有一台pve時, 要知道其它節點有什麼vm
<pre><code>
#!/bin/bash

# 設定表頭
printf "%-15s %-10s %-25s %-20s %-30s\n" "節點" "VMID" "VM名稱" "儲存裝置" "磁碟"
echo "------------------------------------------------------------------------------------------------"

# 遍歷所有節點的設定檔目錄
for node_dir in /etc/pve/nodes/*; do
    node_name=$(basename "$node_dir")

    # 檢查該節點是否有 qemu-server 設定檔
    if [ -d "$node_dir/qemu-server" ]; then
        # 遍歷該節點的所有 VM 設定檔
        for vm_config in "$node_dir"/qemu-server/*.conf; do
            if [ -f "$vm_config" ]; then
                vmid=$(basename "$vm_config" .conf)

                # 使用 grep 從設定檔中提取 VM 名稱
                vmname=$(grep -E "^name:" "$vm_config" | cut -d ':' -f 2 | tr -d '[:space:]')

                # 使用 grep 提取磁碟資訊
                disk_info=$(grep -E "^(disk|scsi|ide|sata)[0-9]+:" "$vm_config")

                # 如果沒有磁碟資訊，則顯示 N/A
                if [ -z "$disk_info" ]; then
                    printf "%-15s %-10s %-25s %-20s %-30s\n" "$node_name" "$vmid" "$vmname" "N/A" "N/A"
                else
                    first_line=true
                    while read -r disk; do
                        storage=$(echo "$disk" | cut -d ':' -f 2 | cut -d ',' -f 1 | cut -d ':' -f 1 | tr -d '[:space:]')
                        disk_details=$(echo "$disk" | cut -d ':' -f 3- | tr -d '[:space:]')
                        if $first_line; then
                            printf "%-15s %-10s %-25s %-20s %-30s\n" "$node_name" "$vmid" "$vmname" "$storage" "$disk_details"
                            first_line=false
                        else
                            printf "%-15s %-10s %-25s %-20s %-30s\n" "" "" "" "$storage" "$disk_details"
                        fi
                    done <<< "$disk_info"
                fi
            fi
        done
    fi
done

</code></pre>
