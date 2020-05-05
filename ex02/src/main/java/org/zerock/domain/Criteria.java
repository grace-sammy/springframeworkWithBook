package org.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Setter
@Getter
public class Criteria {

	private int pageNum;
	private int amount;

	// 검색을 위해 type과 keyword 추가
	private String type;
	private String keyword;

	public Criteria() {
		this(1, 10);
	}

	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}

	// 검색 조건이 각 글자 (T, W, C)로 구성되어 있으므로 검색 조건을 배열로 만듬
	public String[] getTypeArr() {

		return type == null ? new String[] {} : type.split("");
	}
	
	
	//UriComponentsBuilder로 생성된 URL은 화면에서도 유용하게 사용될 수 있는데, 주로 javaScript를 사용할 수 없는 상황에서
	//링크를 처리해야하는 상황에서 사용됨, 또한 한글 처리에 신경쓰지 않아도 된다.
	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.amount)
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
		
		return builder.toUriString();
	}

}