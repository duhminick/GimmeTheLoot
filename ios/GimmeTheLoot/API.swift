//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class ArchiveAllItemsMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation ArchiveAllItems {
      archiveAllItems
    }
    """

  public let operationName = "ArchiveAllItems"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("archiveAllItems", type: .nonNull(.scalar(Bool.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(archiveAllItems: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "archiveAllItems": archiveAllItems])
    }

    public var archiveAllItems: Bool {
      get {
        return resultMap["archiveAllItems"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "archiveAllItems")
      }
    }
  }
}

public final class ArchiveItemMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation ArchiveItem($id: ID!) {
      archiveItem(id: $id)
    }
    """

  public let operationName = "ArchiveItem"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("archiveItem", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.scalar(Bool.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(archiveItem: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "archiveItem": archiveItem])
    }

    public var archiveItem: Bool {
      get {
        return resultMap["archiveItem"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "archiveItem")
      }
    }
  }
}

public final class CreateMonitorMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation CreateMonitor($name: String!, $type: String!, $keywords: [String]!, $url: String!) {
      createMonitor(name: $name, type: $type, keywords: $keywords, url: $url)
    }
    """

  public let operationName = "CreateMonitor"

  public var name: String
  public var type: String
  public var keywords: [String?]
  public var url: String

  public init(name: String, type: String, keywords: [String?], url: String) {
    self.name = name
    self.type = type
    self.keywords = keywords
    self.url = url
  }

  public var variables: GraphQLMap? {
    return ["name": name, "type": type, "keywords": keywords, "url": url]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createMonitor", arguments: ["name": GraphQLVariable("name"), "type": GraphQLVariable("type"), "keywords": GraphQLVariable("keywords"), "url": GraphQLVariable("url")], type: .nonNull(.scalar(Bool.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createMonitor: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createMonitor": createMonitor])
    }

    public var createMonitor: Bool {
      get {
        return resultMap["createMonitor"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "createMonitor")
      }
    }
  }
}

public final class DeleteMonitorMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    mutation DeleteMonitor($id: ID!) {
      deleteMonitor(id: $id)
    }
    """

  public let operationName = "DeleteMonitor"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("deleteMonitor", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.scalar(Bool.self))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteMonitor: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteMonitor": deleteMonitor])
    }

    public var deleteMonitor: Bool {
      get {
        return resultMap["deleteMonitor"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "deleteMonitor")
      }
    }
  }
}

public final class GetItemsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query GetItems($archived: Boolean!) {
      items(archived: $archived) {
        __typename
        id
        name
        url
        price
        date
        source
        archived
      }
    }
    """

  public let operationName = "GetItems"

  public var archived: Bool

  public init(archived: Bool) {
    self.archived = archived
  }

  public var variables: GraphQLMap? {
    return ["archived": archived]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("items", arguments: ["archived": GraphQLVariable("archived")], type: .nonNull(.list(.nonNull(.object(Item.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(items: [Item]) {
      self.init(unsafeResultMap: ["__typename": "Query", "items": items.map { (value: Item) -> ResultMap in value.resultMap }])
    }

    public var items: [Item] {
      get {
        return (resultMap["items"] as! [ResultMap]).map { (value: ResultMap) -> Item in Item(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Item) -> ResultMap in value.resultMap }, forKey: "items")
      }
    }

    public struct Item: GraphQLSelectionSet {
      public static let possibleTypes = ["Item"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("price", type: .scalar(Double.self)),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("source", type: .scalar(String.self)),
        GraphQLField("archived", type: .nonNull(.scalar(Bool.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, url: String, price: Double? = nil, date: String, source: String? = nil, archived: Bool) {
        self.init(unsafeResultMap: ["__typename": "Item", "id": id, "name": name, "url": url, "price": price, "date": date, "source": source, "archived": archived])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var url: String {
        get {
          return resultMap["url"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "url")
        }
      }

      public var price: Double? {
        get {
          return resultMap["price"] as? Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "price")
        }
      }

      public var date: String {
        get {
          return resultMap["date"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }

      public var source: String? {
        get {
          return resultMap["source"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "source")
        }
      }

      public var archived: Bool {
        get {
          return resultMap["archived"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "archived")
        }
      }
    }
  }
}

public final class GetMonitorsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    query GetMonitors {
      monitors {
        __typename
        id
        name
        type
        keywords
        url
      }
    }
    """

  public let operationName = "GetMonitors"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("monitors", type: .nonNull(.list(.nonNull(.object(Monitor.selections))))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(monitors: [Monitor]) {
      self.init(unsafeResultMap: ["__typename": "Query", "monitors": monitors.map { (value: Monitor) -> ResultMap in value.resultMap }])
    }

    public var monitors: [Monitor] {
      get {
        return (resultMap["monitors"] as! [ResultMap]).map { (value: ResultMap) -> Monitor in Monitor(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Monitor) -> ResultMap in value.resultMap }, forKey: "monitors")
      }
    }

    public struct Monitor: GraphQLSelectionSet {
      public static let possibleTypes = ["Monitor"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("type", type: .nonNull(.scalar(String.self))),
        GraphQLField("keywords", type: .nonNull(.list(.scalar(String.self)))),
        GraphQLField("url", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, type: String, keywords: [String?], url: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Monitor", "id": id, "name": name, "type": type, "keywords": keywords, "url": url])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var type: String {
        get {
          return resultMap["type"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }

      public var keywords: [String?] {
        get {
          return resultMap["keywords"]! as! [String?]
        }
        set {
          resultMap.updateValue(newValue, forKey: "keywords")
        }
      }

      public var url: String? {
        get {
          return resultMap["url"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "url")
        }
      }
    }
  }
}

public final class ItemAddedSubscription: GraphQLSubscription {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition =
    """
    subscription ItemAdded {
      itemAdded {
        __typename
        id
        name
        url
        price
        date
        source
        archived
      }
    }
    """

  public let operationName = "ItemAdded"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("itemAdded", type: .nonNull(.object(ItemAdded.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(itemAdded: ItemAdded) {
      self.init(unsafeResultMap: ["__typename": "Subscription", "itemAdded": itemAdded.resultMap])
    }

    public var itemAdded: ItemAdded {
      get {
        return ItemAdded(unsafeResultMap: resultMap["itemAdded"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "itemAdded")
      }
    }

    public struct ItemAdded: GraphQLSelectionSet {
      public static let possibleTypes = ["Item"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("name", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .nonNull(.scalar(String.self))),
        GraphQLField("price", type: .scalar(Double.self)),
        GraphQLField("date", type: .nonNull(.scalar(String.self))),
        GraphQLField("source", type: .scalar(String.self)),
        GraphQLField("archived", type: .nonNull(.scalar(Bool.self))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String, url: String, price: Double? = nil, date: String, source: String? = nil, archived: Bool) {
        self.init(unsafeResultMap: ["__typename": "Item", "id": id, "name": name, "url": url, "price": price, "date": date, "source": source, "archived": archived])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var url: String {
        get {
          return resultMap["url"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "url")
        }
      }

      public var price: Double? {
        get {
          return resultMap["price"] as? Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "price")
        }
      }

      public var date: String {
        get {
          return resultMap["date"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }

      public var source: String? {
        get {
          return resultMap["source"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "source")
        }
      }

      public var archived: Bool {
        get {
          return resultMap["archived"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "archived")
        }
      }
    }
  }
}
