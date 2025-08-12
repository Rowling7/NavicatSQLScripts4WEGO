// 将表格记录下载为Excel文件的脚本
(function() {
    // 创建表头
    const headers = ['序号', '患者ID', '患者姓名', '身份证号', '主要诊断', '住院流水号', '病案号', '状态', '医院名称', '医院ID', '支付方式', '支付地点'];
    
    // 存储所有数据行
    const rows = [];
    
    // 获取所有数据行
    const tableRows = document.querySelectorAll('tr[data-index]');
    
    // 遍历每一行提取数据
    tableRows.forEach(row => {
        const rowData = [];
        
        // 序号 (data-index)
        const index = row.getAttribute('data-index');
        rowData.push(index);
        
        // 患者ID
        const patientIdElement = row.querySelector('td[data-field="patientId"] .layui-table-cell');
        const patientId = patientIdElement ? patientIdElement.textContent.trim() : '';
        rowData.push(patientId);
        
        // 患者姓名
        const patientNameElement = row.querySelector('td[data-field="patientName"] .layui-table-cell');
        const patientName = patientNameElement ? patientNameElement.textContent.trim() : '';
        rowData.push(patientName);
        
        // 身份证号
        const sfzhElement = row.querySelector('td[data-field="sfzh"] .layui-table-cell');
        const sfzh = sfzhElement ? sfzhElement.textContent.trim() : '';
        rowData.push(sfzh);
        
        // 主要诊断
        const zyzdElement = row.querySelector('td[data-field="zyzd"] .layui-table-cell');
        const zyzd = zyzdElement ? zyzdElement.textContent.trim() : '';
        rowData.push(zyzd);
        
        // 住院流水号
        const zylshElement = row.querySelector('td[data-field="zylsh"] .layui-table-cell');
        const zylsh = zylshElement ? zylshElement.textContent.trim() : '';
        rowData.push(zylsh);
        
        // 病案号
        const bahElement = row.querySelector('td[data-field="bah"] .layui-table-cell');
        const bah = bahElement ? bahElement.textContent.trim() : '';
        rowData.push(bah);
        
        // 状态
        const statusElement = row.querySelector('td[data-field="status"] .layui-table-cell');
        const status = statusElement ? statusElement.textContent.trim() : '';
        rowData.push(status);
        
        // 医院名称
        const usernameElement = row.querySelector('td[data-field="username"] .layui-table-cell');
        const username = usernameElement ? usernameElement.textContent.trim() : '';
        rowData.push(username);
        
        // 医院ID
        const useridElement = row.querySelector('td[data-field="userid"] .layui-table-cell');
        const userid = useridElement ? useridElement.textContent.trim() : '';
        rowData.push(userid);
        
        // 支付方式
        const ylfkfsElement = row.querySelector('td[data-field="ylfkfs"] .layui-table-cell');
        const ylfkfs = ylfkfsElement ? ylfkfsElement.textContent.trim() : '';
        rowData.push(ylfkfs);
        
        // 支付地点
        const payLocElement = row.querySelector('td[data-field="payLoc"] .layui-table-cell');
        const payLoc = payLocElement ? payLocElement.textContent.trim() : '';
        rowData.push(payLoc);
        
        rows.push(rowData);
    });
    
    // 创建CSV内容
    const csvContent = [
        headers.join(','), // 添加表头
        ...rows.map(row => row.map(cell => {
            // 处理包含逗号或引号的单元格
            const cellStr = String(cell);
            if (cellStr.includes(',') || cellStr.includes('"')) {
                return `"${cellStr.replace(/"/g, '""')}"`;
            }
            return cellStr;
        }).join(','))
    ].join('\n');
    
    // 创建Excel文件并下载
    const blob = new Blob(['\ufeff' + csvContent], { 
        type: 'text/csv;charset=utf-8;' 
    });
    
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.setAttribute('href', url);
    link.setAttribute('download', '患者数据.csv');
    link.style.visibility = 'hidden';
    
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    console.log(`已导出 ${rows.length} 条记录到 Excel 文件`);
})();