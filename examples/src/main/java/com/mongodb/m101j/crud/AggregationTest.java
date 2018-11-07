package com.mongodb.m101j.crud;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.bson.Document;
import org.bson.conversions.Bson;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Accumulators;
import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;

public class AggregationTest {
	public static void main(String[] args) {
		MongoClient client = new MongoClient();
		MongoDatabase database = client.getDatabase("course");
		MongoCollection<Document> collection = database.getCollection("zips");
//		List<Document> pipeline = Arrays.asList(
//				new Document("$group", new Document("_id", "$state")
//						.append("totalPop", new Document("$sum", "$pop"))),
//				new Document("$match", new Document("totalPop", new Document("$gte",10000))));
		
		List<Bson> pipeline	= Arrays.asList(Aggregates.group("$state", Accumulators.sum("totalPop", "$pop")), Aggregates.match(Filters.gte("totalPop", 1000000)));
//		List<Bson> pipeline	 = Arrays.asList(Document.parse("{ $group: { _id: \"$state\", totalPop: { $sum: \"$pop\" } } }"),Document.parse("{ $match: { totalPop: { $gte: 10000 } } }"));
//		List<Document> results = collection.find().into(new ArrayList<Document>());
		
		List<Document> results = collection.aggregate(pipeline).into(new ArrayList<Document>());
		
		results.stream().forEach((d) -> {System.out.println(d.toJson());});
	}
}
