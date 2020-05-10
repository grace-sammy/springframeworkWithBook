<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="../includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Read</h1>
	</div>
	<!--  /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Read Page</div>
			<!-- /.panel-heading -->

			<div class="panel-body">

				<div class="form-group">
					<label>Bno</label>
					<input class="form-control" name='bno' readOnly="readonly" value='<c:out value="${board.bno}"/>'>
				</div>

				<div class="form-group">
					<label>Title</label>
					<input class="form-control" name='title' readOnly="readonly" value='<c:out value="${board.title}"/>'>
				</div>

				<div class="form-group">
					<label>Text area</label>
					<textarea class="form-control" rows="3" name='content' readOnly="readonly"><c:out value="${board.content}" /></textarea>
				</div>

				<div class="form-group">
					<label>Writer</label>
					<input class="form-control" name='writer' readOnly="readonly">
				</div>

				<%--1.  직접 링크를 걸어서 처리하는 방법 , 이것 두줄 사용
				<button data-oper='modify' class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno }"/>'">Modify</button>
				<button data-oper='list' class="btn btn-default" onclick="location.href='/board/list'">List</button> --%>

				<!--2. 직접 링크를 걸지 않는 방법 -->
				<button data-oper='modify' class="btn btn-default">Modify</button>
				<button data-oper='list' class="btn btn-info">List</button>


				<!-- 브라우저에서는 form 태그의 내용은 보이지 않고 버튼만이 보이게 된다. 사용자가 버튼을 클릭하면 openForm이라는 id를 가진 <form>태그를 전송해야
				하므로 추가적인 JavaScript 처리가 필요 -->

				<form id='operForm' action="/board/modify" method="get">
					<input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
					<!--pageNum, amount 값을 같이 전달해줄 경우, 글을 읽은 후 리스트로 돌아갈때 보던 리스트로 돌아갈 수 있다. -->
					<!--  http://localhost:8080/board/list?pageNum=5&amount=10  이렇게 전달이 된다.-->
					<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
					<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
					<input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
					<input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>
				</form>
			</div>
			<!-- end panel-body -->
		</div>
		<!-- end panel-body -->
	</div>
	<!-- end panel -->
</div>
<!-- /.row -->

<div class='row'>
	<div class="col-lg-12">
		<div class="panel panel-default">
		<!-- <div class="panel-heading"><i class="fa fa-comments fa-fw"></i> Reply</div> -->
		
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> Reply
				<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
			</div>
			
			<div class="panel-body">
				<ul class="chat">
				</ul>
			</div>
			<!-- panel-footer에 댓글 페이지 번호를 출력 -->
			<div class="panel-footer"></div>
		</div>
	</div>
	<!-- end of row -->
</div>


<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name='reply' value='New Reply!!!!'>
				</div>
				<div class="form-group">
					<label>Replyer</label>
					<input class="form-control" name='replyer' value='replyer'>
				</div>
				<div class="form-group">
					<label>Reply Date</label>
					<input class="form-control" name='replyDate' value='2018-01-01 13:13'>
				</div>

			</div>
			<div class="modal-footer">
				<button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
				<button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
				<button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
				<button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
			</div>
		</div>
		<!-- /.modal-content -->
	</div>
	<!-- /.modal-dialog -->
</div>
<!-- /.modal -->


<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
$(document).ready(function () {
	  
	  var bnoValue = '<c:out value="${board.bno}"/>';
	  var replyUL = $(".chat");
	  
	    showList(1);
	    
	    //파라미터로 전달되는 page 변수를 이용해서 원하는 댓글 페이지를 가져오게 된다. 이때 만일 page 번호가 -1로 전달되면,
	    //마지막 페이지를 찾아서 다시 호출하게 된다. 사용자가 새로운 댓글을 추가하면 showList(-1);을 호출하여 우선 전체 댓글의 숫자를 파악한다
	    //이 후에 다시 마지막 페이지를 호출해서 이동시키는 방식으로 동작한다.
	    //이러한 방식은 여러 번 서버를 호출해야하는 단점이 있으나 ...
	function showList(page){
		 console.log("show list " + page);
	    
	    replyService.getList({bno:bnoValue, page: page|| 1 }, function(replyCnt, list) {
	      
	    console.log("replyCnt: "+ replyCnt );
	    console.log("list: " + list);
	    console.log(list);
	    
	    if(page == -1){
	      pageNum = Math.ceil(replyCnt/10.0);
	      showList(pageNum);
	      return;
	    }
	      
	     var str="";
	     
	     if(list == null || list.length == 0){
	       return;
	     }
	     
	     for (var i = 0, len = list.length || 0; i < len; i++) {
	       str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
	       str +="  <div><div class='header'><strong class='primary-font'>["
	    	   +list[i].rno+"] "+list[i].replyer+"</strong>"; 
	       str +="    <small class='pull-right text-muted'>"
	           +replyService.displayTime(list[i].replyDate)+"</small></div>";
	       str +="    <p>"+list[i].reply+"</p></div></li>";
	     }
	     
	     replyUL.html(str);
	     
	     showReplyPage(replyCnt);

	 
	   });//end function
	     
	 }//end showList
	 
	    
	 //댓글 페이지 번호를 출력하는 로직
	    var pageNum = 1;
	    var replyPageFooter = $(".panel-footer");
	    
	    function showReplyPage(replyCnt){
	      var endNum = Math.ceil(pageNum / 10.0) * 10;  
	      var startNum = endNum - 9; 
	      var prev = startNum != 1;
	      var next = false;
	      
	      if(endNum * 10 >= replyCnt){
	        endNum = Math.ceil(replyCnt/10.0);
	      }
	      
	      if(endNum * 10 < replyCnt){
	        next = true;
	      }
	      
	      var str = "<ul class='pagination pull-right'>";
	      
	      if(prev){
	        str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
	      }
	      
	      for(var i = startNum ; i <= endNum; i++){
	        
	        var active = pageNum == i? "active":"";
	        
	        str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
	      }
	      
	      if(next){
	        str+= "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
	      }
	      
	      str += "</ul></div>";
	      console.log(str);
	      replyPageFooter.html(str);
	    }
	     
	    
	  /*   페이지의 번호를 클릭했을 때 새로운 댓글을 가져오도록 */
	    //댓글의 페이지 번호는 <a>태그 내에 존재하므로 이벤트 처리에서는 <a>태그의 기본 동작을 제한(preventDefault)
	    replyPageFooter.on("click","li a", function(e){
	       e.preventDefault();
	       console.log("page click");
	       
	       
	       var targetPageNum = $(this).attr("href");
	       console.log("targetPageNum: " + targetPageNum);
	       pageNum = targetPageNum;
	       showList(pageNum);
	     });     

	    
	/*     function showList(page){
	      
	      replyService.getList({bno:bnoValue,page: page|| 1 }, function(list) {
	        
	        var str="";
	       if(list == null || list.length == 0){
	        
	        replyUL.html("");
	        
	        return;
	      }
	       for (var i = 0, len = list.length || 0; i < len; i++) {
	           str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
	           str +="  <div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>"; 
	           str +="    <small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
	           str +="    <p>"+list[i].reply+"</p></div></li>";
	         }


	    replyUL.html(str);

	      });//end function
	      
	   }//end showList */
	   
	   
	    var modal = $(".modal");
	    var modalInputReply = modal.find("input[name='reply']");
	    var modalInputReplyer = modal.find("input[name='replyer']");
	    var modalInputReplyDate = modal.find("input[name='replyDate']");
	    
	    var modalModBtn = $("#modalModBtn");
	    var modalRemoveBtn = $("#modalRemoveBtn");
	    var modalRegisterBtn = $("#modalRegisterBtn");
	    
	    $("#modalCloseBtn").on("click", function(e){
	    	
	    	modal.modal('hide');
	    });
	    
	    $("#addReplyBtn").on("click", function(e){
	      
	      modal.find("input").val("");
	      modalInputReplyDate.closest("div").hide();
	      modal.find("button[id !='modalCloseBtn']").hide();
	      
	      modalRegisterBtn.show();
	      
	      $(".modal").modal("show");
	      
	    });
	    

	    
	    modalRegisterBtn.on("click", function(e){
	        
	      var reply = {
	            reply: modalInputReply.val(),
	            replyer:modalInputReplyer.val(),
	            bno:bnoValue
	          };
	      
	      replyService.add(reply, function(result){
	        
	        alert(result);
	        
	        modal.find("input").val("");
	        modal.modal("hide");
	        
	        //showList(1);
	        showList(-1);
	        
	      });
	      
	    });


	  //댓글 조회 클릭 이벤트 처리 
	    $(".chat").on("click", "li", function(e){
	      
	      var rno = $(this).data("rno");
	      
	      replyService.get(rno, function(reply){
	      
	        modalInputReply.val(reply.reply);
	        modalInputReplyer.val(reply.replyer);
	        modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
	        modal.data("rno", reply.rno);
	        
	        modal.find("button[id !='modalCloseBtn']").hide();
	        modalModBtn.show();
	        modalRemoveBtn.show();
	        
	        $(".modal").modal("show");
	            
	      });
	    });
	  
	    
	/*     modalModBtn.on("click", function(e){
	      
	      var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
	      
	      replyService.update(reply, function(result){
	            
	        alert(result);
	        modal.modal("hide");
	        showList(1);
	        
	      });
	      
	    });

	    modalRemoveBtn.on("click", function (e){
	    	  
	  	  var rno = modal.data("rno");
	  	  
	  	  replyService.remove(rno, function(result){
	  	        
	  	      alert(result);
	  	      modal.modal("hide");
	  	      showList(1);
	  	      
	  	  });
	  	  
	  	}); */

	  	
	    modalModBtn.on("click", function(e){
	    	  
	   	  var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
	   	  
	   	  replyService.update(reply, function(result){
	   	        
	   	    alert(result);
	   	    modal.modal("hide");
	   	    showList(pageNum);
	   	  });
	   	  
	   	});


	   	modalRemoveBtn.on("click", function (e){
	   	  var rno = modal.data("rno");
	   	  replyService.remove(rno, function(result){
	   	      alert(result);
	   	      modal.modal("hide");
	   	      showList(pageNum);
	   	      
	   	  });
	   	  
	   	});
	});

	</script>


<script type="text/javascript">
	$(document).ready(function() {

		var operForm = $("#operForm");

		//사용자가 수정버튼을 누르는 순간
		//$("태그[속성명=속성값]") == $(":input태그의 type명") ex) $(":checkbox")
		$("button[data-oper='modify']").on("click", function(e) {

			operForm.attr("action", "/board/modify").submit();

		});

		//사용자가 list로 이동하는 경우 아직 아무런 데이터도 필요하지 않으므로 form태그 내의 bno태그를 지우고 submit을 통해서 리스트 페이지로 이동
		$("button[data-oper='list']").on("click", function(e) {

			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list")
			operForm.submit();

		});
	});
</script>
<%@include file="../includes/footer.jsp"%>