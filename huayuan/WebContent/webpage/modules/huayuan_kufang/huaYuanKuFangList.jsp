<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>库房管理管理</title>
	<meta name="decorator" content="default"/>
	<%@include file="/webpage/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, ids = [], rootIds = [];
			for (var i=0; i<data.length; i++){
				ids.push(data[i].id);
			}
			ids = ',' + ids.join(',') + ',';
			for (var i=0; i<data.length; i++){
				if (ids.indexOf(','+data[i].parentId+',') == -1){
					if ((','+rootIds.join(',')+',').indexOf(','+data[i].parentId+',') == -1){
						rootIds.push(data[i].parentId);
					}
				}
			}
			for (var i=0; i<rootIds.length; i++){
				addRow("#treeTableList", tpl, data, rootIds[i], true);
			}
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
							liexin: getDictLabel(${fns:toJson(fns:getDictList('kufang_type'))}, row.liexin),
						blank123:0}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
		
		function refresh(){//刷新
			
			window.location="${ctx}/huayuan_kufang/huaYuanKuFang/";
		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<div class="ibox">
	<div class="ibox-title">
			<h5>库房管理列表 </h5>
			<div class="ibox-tools">
				<a class="collapse-link">
					<i class="fa fa-chevron-up"></i>
				</a>
				<a class="dropdown-toggle" data-toggle="dropdown" href="form_basic.html#">
					<i class="fa fa-wrench"></i>
				</a>
				<ul class="dropdown-menu dropdown-user">
					<li><a href="#">选项1</a>
					</li>
					<li><a href="#">选项2</a>
					</li>
				</ul>
				<a class="close-link">
					<i class="fa fa-times"></i>
				</a>
			</div>
	</div>
    
    <div class="ibox-content">
	<sys:message content="${message}"/>

	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="huaYuanKuFang" action="${ctx}/huayuan_kufang/huaYuanKuFang/" method="post" class="form-inline">
		<div class="form-group">
				<label>库房名字：</label>
				<form:input path="name" htmlEscape="false" maxlength="64" class="form-control input-sm"/>
				<label>类型：</label>
				<form:select path="liexin" class="form-control m-b">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('kufang_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<label>库房编号：</label>
				<form:input path="number" htmlEscape="false" maxlength="64" class="form-control input-sm"/>
		</div>
	</form:form>
	<br/>
	</div>
	</div>
	
	<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<shiro:hasPermission name="huayuan_kufang:huaYuanKuFang:add">
				<table:addRow url="${ctx}/huayuan_kufang/huaYuanKuFang/form" title="库房管理"></table:addRow><!-- 增加按钮 -->
			</shiro:hasPermission>
	       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="refresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
		</div>
		<div class="pull-right">
			<button  class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
			<button  class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="reset()" ><i class="fa fa-refresh"></i> 重置</button>
		</div>
	</div>
	</div>
	
	<table id="treeTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
		<thead>
			<tr>
				<th>库房名字</th>
				<th>类型</th>
				<th>库房编号</th>
				<th>备注信息</th>
				<shiro:hasPermission name="huayuan_kufang:huaYuanKuFang:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody id="treeTableList"></tbody>
	</table>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td><a  href="#" onclick="openDialogView('查看库房管理', '${ctx}/huayuan_kufang/huaYuanKuFang/form?id={{row.id}}','800px', '500px')">
				{{row.name}}
			</a></td>
			<td>
				{{dict.liexin}}
			</td>
			<td>
				{{row.number}}
			</td>
			<td>
				{{row.remarks}}
			</td>
			<td>
			<shiro:hasPermission name="huayuan_kufang:huaYuanKuFang:view">
				<a href="#" onclick="openDialogView('查看库房管理', '${ctx}/huayuan_kufang/huaYuanKuFang/form?id={{row.id}}','800px', '500px')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i>  查看</a>
				</shiro:hasPermission>
			<shiro:hasPermission name="huayuan_kufang:huaYuanKuFang:edit">
   				<a href="#" onclick="openDialog('修改库房管理', '${ctx}/huayuan_kufang/huaYuanKuFang/form?id={{row.id}}','800px', '500px')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
   			</shiro:hasPermission>
   			<shiro:hasPermission name="huayuan_kufang:huaYuanKuFang:del">
				<a href="${ctx}/huayuan_kufang/huaYuanKuFang/delete?id={{row.id}}" onclick="return confirmx('确认要删除该库房管理及所有子库房管理吗？', this.href)" class="btn btn-danger btn-xs" ><i class="fa fa-trash"></i> 删除</a>
			</shiro:hasPermission>
   			<shiro:hasPermission name="huayuan_kufang:huaYuanKuFang:add">
				<a href="#" onclick="openDialog('添加下级库房管理', '${ctx}/huayuan_kufang/huaYuanKuFang/form?parent.id={{row.id}}','800px', '500px')" class="btn btn-primary btn-xs" ><i class="fa fa-plus"></i> 添加下级库房管理</a>
			</shiro:hasPermission>
			</td>
		</tr>
	</script>
</body>
</html>