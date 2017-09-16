//
//  Marvel_HeroesTests.swift
//  Marvel HeroesTests
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import XCTest
@testable import Marvel_Heroes

class Marvel_HeroesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCharactersResponse() {
        
        let characters = Marvel.characters(limit: 20, offset: 0, name: nil, nameStartsWith: nil)
        let responseData = characters.sampleData
        
        XCTAssertNoThrow(try MarvelResponse<Hero>(with: responseData), "Marvel characters response could not be parsed")
        
        let heroes = try! MarvelResponse<Hero>(with: responseData).data?.results
        let hero = heroes?.first
        
        XCTAssertNotNil(hero, "No character loaded")
        XCTAssertTrue(hero?.name == "3-D Man", "First hero must be 3-D Man")
        XCTAssertTrue(hero?.id == 1011334, "3-D Man id is wrong")
        
        // Testing get summaries id
        
        XCTAssertNotNil(hero?.comics?.first?.comicID, "Couldn't get the id from comic resourceURI")
        XCTAssertNotNil(hero?.events?.first?.eventID, "Couldn't get the id from event resourceURI")
        XCTAssertNotNil(hero?.stories?.first?.storyID, "Couldn't get the id from story resourceURI")
        XCTAssertNotNil(hero?.series?.first?.serieID, "Couldn't get the id from serie resourceURI")
    }
    
    func testComicsResponse() {
        let comicRoute = Marvel.comic(id: 16162)
        let responseData = comicRoute.sampleData
        
        XCTAssertNoThrow(try MarvelResponse<Comic>(with: responseData), "Marvel comic response could not be parsed")
        
        let comic = try! MarvelResponse<Comic>(with: responseData).data?.results!.first
        
        XCTAssertNotNil(comic, "Comic could not be loaded")
        XCTAssertTrue(comic?.id == 16162, "Comic should have the id: 16162")
        XCTAssertTrue(comic?.title == "Avengers: The Initiative (2007) #5", "Unexpected title for comic with id 16162")
    }
    
    func testEventsResponse() {
        let eventRoute = Marvel.event(id: 269)
        let responseData = eventRoute.sampleData
        
        XCTAssertNoThrow(try MarvelResponse<Event>(with: responseData), "Marvel event response could not be parsed")
        
        let event = try! MarvelResponse<Event>(with: responseData).data?.results!.first
        
        XCTAssertNotNil(event, "Event could not be loaded")
        XCTAssertTrue(event?.id == 269, "Event should have the id: 269")
        XCTAssertTrue(event?.title == "Secret Invasion", "Unexpected title for event with id 269")
    }
    
    func testSeriesResponse() {
        let serieRoute = Marvel.serie(id: 1945)
        let responseData = serieRoute.sampleData
        
        XCTAssertNoThrow(try MarvelResponse<Serie>(with: responseData), "Marvel serie response could not be parsed")
        
        let serie = try! MarvelResponse<Serie>(with: responseData).data?.results!.first
        
        XCTAssertNotNil(serie, "Serie could not be loaded")
        XCTAssertTrue(serie?.id == 1945, "Serie should have the id: 1945")
        XCTAssertTrue(serie?.title == "Avengers: The Initiative (2007 - 2010)", "Unexpected title for serie with id 1945")
    }
    
    func testStoriesResponse() {
        let storyRoute = Marvel.story(id: 19947)
        let responseData = storyRoute.sampleData
        
        XCTAssertNoThrow(try MarvelResponse<Story>(with: responseData), "Marvel story response could not be parsed")
        
        let story = try! MarvelResponse<Story>(with: responseData).data?.results!.first
        
        XCTAssertNotNil(story, "Story could not be loaded")
        XCTAssertTrue(story?.id == 19947, "Story should have the id: 19947")
        XCTAssertTrue(story?.title == "Cover #19947", "Unexpected title for story with id 19947")
    }
    
    func testMD5Digest() {
        
        XCTAssertNotNil(Marvel.apiKey, "API public key could not be found.")
        XCTAssertNotNil(Marvel.secret, "API private key could not be found.")
        
        
        let timestamp = "\(Date(timeIntervalSince1970: 1000))"
        let token = timestamp + "750d32977a7179805ff21" + "999e4583e4d314eadf01c9cade"
        
        XCTAssertNotNil(token.md5, "MD5 could not be generated")
        print(token.md5!)
        
        XCTAssertTrue(token.md5! == "e5632574475526b42d9fe6e6eb81fdd5", "Bad MD5 digest")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
