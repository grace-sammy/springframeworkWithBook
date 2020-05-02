package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;


//페이징 처리를 위한 클래스

@Getter
@ToString
public class PageDTO {
	
	  private int startPage;
	  private int endPage;
	  private boolean prev, next;

	  private int total;
	  private Criteria cri;

	
	  public PageDTO(Criteria cri, int total) {

		    this.cri = cri;
		    this.total = total;
		
		//페이지 끝 번호를 계산(끝번호 먼저 계산하는 것이 수월)
		this.endPage=(int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;
		
		//만일 화면에 10개씩 보여준다면 시작 번호(startPage)는 무조건 끝 번호(endPage)에서 9를 뺸 값
		this.startPage=this.endPage -9;
		
		//total을 통한 endPage의 재계산
		int realEnd = (int) (Math.ceil((total*1.0) / cri.getAmount()));
		if(realEnd < this.endPage) {
			this.endPage = realEnd;
		}
		
		//이전 페이지 계산, 이전의 경우는 시작 번호(startPage)가 1보다 큰 경우 존재
		this.prev = this.startPage > 1;
		//다음 페이지 계산, 다음의 경우 realEnd가 끝 번호(endPage)보다 큰 경우 존재
		this.next = this.endPage < realEnd;
	}
}
