//
//  DemoData.swift
//  AG Veri Maskeleme
//
//  Created by Ata Gürsel on 10.11.2025.
//

import Foundation

struct DemoData {
    static let sampleCSV = """
id,ad,soyad,tc_kimlik,email,telefon,iban,adres,departman
1,Ahmet,Yılmaz,12345678901,ahmet.yilmaz@example.com,05321234567,TR180006200119000006672315,İstanbul Kadıköy,Yazılım
2,Ayşe,Demir,98765432109,ayse.demir@example.com,05421234567,TR750006200119000009992318,Ankara Çankaya,İnsan Kaynakları
3,Mehmet,Kaya,11223344556,mehmet.kaya@example.com,05331234567,TR520006200119000002222110,İzmir Bornova,Finans
4,Fatma,Şahin,66778899001,fatma.sahin@example.com,05551234567,TR330006200119000001110005,Bursa Nilüfer,Pazarlama
5,Ali,Çelik,33221144556,ali.celik@example.com,05441234567,TR990006200119000004560013,Antalya Muratpaşa,Satış
6,Zeynep,Arslan,77889966554,zeynep.arslan@example.com,05361234567,TR120006200119000007773316,İstanbul Beşiktaş,Yazılım
7,Mustafa,Özdemir,44556677889,mustafa.ozdemir@example.com,05531234567,TR880006200119000005554411,Ankara Etimesgut,Operasyon
8,Elif,Yıldız,22334455667,elif.yildiz@example.com,05451234567,TR440006200119000003338812,İzmir Konak,Destek
9,Can,Aydın,99887766554,can.aydin@example.com,05341234567,TR660006200119000008889913,Bursa Osmangazi,Yazılım
10,Selin,Kurt,55443322110,selin.kurt@example.com,05521234567,TR220006200119000001112214,Antalya Kepez,Finans
"""
    
    static let sampleJSON = """
[
  {
    "id": "1",
    "ad": "Ahmet",
    "soyad": "Yılmaz",
    "tc_kimlik": "12345678901",
    "email": "ahmet.yilmaz@example.com",
    "telefon": "05321234567",
    "iban": "TR180006200119000006672315",
    "adres": "İstanbul Kadıköy",
    "departman": "Yazılım"
  },
  {
    "id": "2",
    "ad": "Ayşe",
    "soyad": "Demir",
    "tc_kimlik": "98765432109",
    "email": "ayse.demir@example.com",
    "telefon": "05421234567",
    "iban": "TR750006200119000009992318",
    "adres": "Ankara Çankaya",
    "departman": "İnsan Kaynakları"
  },
  {
    "id": "3",
    "ad": "Mehmet",
    "soyad": "Kaya",
    "tc_kimlik": "11223344556",
    "email": "mehmet.kaya@example.com",
    "telefon": "05331234567",
    "iban": "TR520006200119000002222110",
    "adres": "İzmir Bornova",
    "departman": "Finans"
  }
]
"""
    
    static func loadDemoCSV() -> ImportedDataset? {
        let lines = sampleCSV.split(separator: "\n").map(String.init)
        guard !lines.isEmpty else { return nil }
        
        let columns = lines[0].split(separator: ",").map(String.init)
        let dataLines = Array(lines.dropFirst())
        
        let rows = dataLines.map { line -> DataRow in
            let values = line.split(separator: ",").map(String.init)
            var rowDict: [String: String] = [:]
            for (index, column) in columns.enumerated() {
                if index < values.count {
                    rowDict[column] = values[index]
                }
            }
            return DataRow(values: rowDict)
        }
        
        return ImportedDataset(
            format: .csv,
            columns: columns,
            rows: rows,
            fileName: "demo_data.csv"
        )
    }
    
    static func loadDemoJSON() -> ImportedDataset? {
        guard let jsonData = sampleJSON.data(using: .utf8),
              let jsonArray = try? JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]],
              !jsonArray.isEmpty else {
            return nil
        }
        
        // Extract columns from first object
        let columns = Array(jsonArray[0].keys).sorted()
        
        let rows = jsonArray.map { obj -> DataRow in
            var values: [String: String] = [:]
            for (key, value) in obj {
                values[key] = "\(value)"
            }
            return DataRow(values: values)
        }
        
        return ImportedDataset(
            format: .json,
            columns: columns,
            rows: rows,
            fileName: "demo_data.json"
        )
    }
}
