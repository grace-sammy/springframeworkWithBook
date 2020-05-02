<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>


<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Modify</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">Board Modify</div>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<form role="form" action="/board/modify" method="post">

					<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum }"/>'> <input type='hidden' name='amount' value='<c:out value="${cri.amount }"/>'> <input type='hidden' name='type' value='<c:out value="${cri.type }"/>'> <input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'>


					<div class="form-group">
						<label>Bno</label> <input class="form-control" name='bno' value='<c:out value="${board.bno }"/>' readonly="readonly">
					</div>

					<div class="form-group">
						<label>Title</label> <input class="form-control" name='title' value='<c:out value="${board.title }"/>'>
					</div>

					<div class="form-group">
						<label>Text area</label>
						<textarea class="form-control" rows="3" name='content'><c:out value="${board.content}" /></textarea>
					</div>

					<div class="form-group">
						<label>Writer</label> <input class="form-control" name='writer' value='<c:out value="${board.writer}"/>' readonly="readonly">
					</div>

					<div class="form-group">
						<label>RegDate</label> <input class="form-control" name='regDate' value='<fmt:formatDate pattern = "yyyy/MM/dd" value = "${board.regdate}" />' readonly="readonly">
					</div>

					<div class="form-group">
						<label>Update Date</label> <input class="form-control" name='updateDate' value='<fmt:formatDate pattern = "yyyy/MM/dd" value = "${board.updateDate}" />' readonly="readonly">
					</div>



					<button type="submit" data-oper='modify' class="btn btn-default">Modify</button>
					<button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
					<button type="submit" data-oper='list' class="btn btn-info">List</button>
				</form>


			</div>
			<!--  end panel-body -->

		</div>
		<!--  end panel-body -->
	</div>
	<!-- end panel -->
</div>
<!-- /.row -->

<script type="text/javascript">

	$(document).ready(function() {

		var formObj = $("form");

		$('button').on("click", function(e) {

			//html 에서 a 태그나 submit 태그는 고유의 동작이 있다.
			//페이지를 이동시킨다거나 form 안에 있는 input 등을 전송한다던가 그러한 동작이 있는데 e.preventDefault는 그 동작을 중단시킨다.
			//e.preventDefault로 기본 동작을 막고 마지막에 직접 submit()을 수행
			e.preventDefault();

			//button 태그의 oper 속성을 이용하여 원하는 기능을 동작하도록 처리
			var operation = $(this).data("oper");

			console.log(operation);

			if (operation === 'remove') {
				//action이라는 속성에 "board/remove" 값 추가
				formObj.attr("action", "/board/remove");

			} else if (operation === 'list') {
				//move to list
				formObj.attr("action", "/board/list").attr("method", "get");

				//$("태그[속성명=속성값]")
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();

				//수정화면에서 /board/list로의 이동은 아무런 파라미터기 없기 때문에 form태그의 모든 내용은 비운다.
				formObj.empty();

				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
			}

			formObj.submit();
		});

	});
</script>


<%@include file="../includes/footer.jsp"%>
