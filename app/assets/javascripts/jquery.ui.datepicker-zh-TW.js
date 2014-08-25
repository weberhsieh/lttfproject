/* Chinese initialisation for the jQuery UI date picker plugin. */
2	/* Written by Ressol (ressol@gmail.com). */
3	jQuery(function($){
4	        $.datepicker.regional['zh-TW'] = {
5	                closeText: '關閉',
6	                prevText: '&#x3C;上月',
7	                nextText: '下月&#x3E;',
8	                currentText: '今天',
9	                monthNames: ['一月','二月','三月','四月','五月','六月',
10	                '七月','八月','九月','十月','十一月','十二月'],
11	                monthNamesShort: ['一月','二月','三月','四月','五月','六月',
12	                '七月','八月','九月','十月','十一月','十二月'],
13	                dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
14	                dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
15	                dayNamesMin: ['日','一','二','三','四','五','六'],
16	                weekHeader: '周',
17	                dateFormat: 'yy/mm/dd',
18	                firstDay: 1,
19	                isRTL: false,
20	                showMonthAfterYear: true,
21	                yearSuffix: '年'};
22	        $.datepicker.setDefaults($.datepicker.regional['zh-TW']);
23	});