;SQLite Functions
;SQLiteSelectData(<byRef Array for Return Data>,<SQLite3 Query>,<SQLite3 Database Path+Filename>)
;SQLiteInsertData(<Array of Data to Insert>,<Table Name>,<SQLite3 Database Path+Filename>)
;SQLiteUpdateData(<Array of Updated Data>,<Table Name>,<Condition>,<SQLite3 Database Path+Filename>)

;JSON Functions
;SelectDataFromJSON(<byRef Array for Return Data>,<JSON Path+Filename>)
;InsertDataIntoJSON(<Array of Data to Insert>,<JSON Path+Filename>)
;UpdateDataInJSON(<Array of Updated Data>,<IndeX>,<JSON Path+Filename>)


#requires autoHotkey v2.0+
#singleInstance
#warn all,off

SQLiteDLL := "./redist/sqlite3.dll"

SQLiteSelectData(&resultArray, query, dbName) {
    sqlite3 := DllCall("LoadLibrary", Str, "sqlite3.dll", "Ptr")
    VarSetCapacity(db, 4)
    DllCall("sqlite3_open", Str, dbName, PtrP, &db)
    stmt := 0
    DllCall("sqlite3_prepare_v2", Ptr, &db, Str, query, Int, -1, PtrP, &stmt, Ptr, 0)
    resultArray := []
    Loop {
        DllCall("sqlite3_step", Ptr, stmt, "Int")
        if (ErrorLevel != 100)  ; SQLITE_ROW
            break
        row := []
        cols := DllCall("sqlite3_column_count", Ptr, stmt, "Int")
        Loop cols {
            colType := DllCall("sqlite3_column_type", Ptr, stmt, "Int", A_Index - 1, "Int")
            if (colType = 1)  ; SQLITE_INTEGER
                value := DllCall("sqlite3_column_int", Ptr, stmt, "Int", A_Index - 1, "Int")
            else if (colType = 2)  ; SQLITE_FLOAT
                value := DllCall("sqlite3_column_double", Ptr, stmt, "Int", A_Index - 1, "CDouble")
            else
                value := DllCall("sqlite3_column_text", Ptr, stmt, "Int", A_Index - 1, PtrP, 0, PtrP, 0)
            row.Push(value)
        }
        resultArray.Push(row)
    }
    DllCall("sqlite3_finalize", Ptr, stmt)
    DllCall("sqlite3_close", Ptr, &db)
    DllCall("FreeLibrary", Ptr, sqlite3)
}

SQLiteQuery(dataArray, query, dbName) {
    sqlite3 := DllCall("LoadLibrary", Str, "sqlite3.dll", "Ptr")
    VarSetCapacity(db, 4)
    DllCall("sqlite3_open", Str, dbName, PtrP, &db)
    DllCall("sqlite3_exec", Ptr, &db, Str, query, Ptr, 0, Ptr, 0, PtrP, 0)
    DllCall("sqlite3_close", Ptr, &db)
    DllCall("FreeLibrary", Ptr, sqlite3)
}

SQLiteInsertData(dataArray, tableName, dbName) {
    sqlite3 := DllCall("LoadLibrary", Str, "sqlite3.dll", "Ptr")
    VarSetCapacity(db, 4)
    DllCall("sqlite3_open", Str, dbName, PtrP, &db)
    query := "INSERT INTO " . tableName . " VALUES ("
    Loop dataArray.MaxIndex() {
        value := dataArray[A_Index]
        if (IsObject(value))
            value := value.0
        query .= (A_Index > 1 ? ", " : "") . (IsObject(value) ? "'" . value . "'" : value)
    }
    query .= ")"
    DllCall("sqlite3_exec", Ptr, &db, Str, query, Ptr, 0, Ptr, 0, PtrP, 0)
    DllCall("sqlite3_close", Ptr, &db)
    DllCall("FreeLibrary", Ptr, sqlite3)
}

SQLiteUpdateData(dataArray, tableName, condition, dbName) {
    sqlite3 := DllCall("LoadLibrary", Str, "sqlite3.dll", "Ptr")
    VarSetCapacity(db, 4)
    DllCall("sqlite3_open", Str, dbName, PtrP, &db)
    query := "UPDATE " . tableName . " SET "
    Loop dataArray.MaxIndex() {
        col := dataArray[A_Index]
        if (IsObject(col)) {
            colName := col.0
            colValue := col.1
            query .= (A_Index > 1 ? ", " : "") . colName . " = " . (IsObject(colValue) ? "'" . colValue . "'" : colValue)
        }
    }
    query .= " WHERE " . condition
    DllCall("sqlite3_exec", Ptr, &db, Str, query, Ptr, 0, Ptr, 0, PtrP, 0)
    DllCall("sqlite3_close", Ptr, &db)
    DllCall("FreeLibrary", Ptr, sqlite3)
}

SelectDataFromJSON(&resultArray, filePath) {
    FileRead(jsonData,filePath)
    resultArray := []
    resultArray := JsonLoad(jsonData)
}

InsertDataIntoJSON(dataArray, filePath) {
    FileRead(jsonData,filePath)
    data := JsonLoad(jsonData)
    data.Push(dataArray)
    json := JsonDump(data)
    FileDelete(filePath)
    FileAppend(json,filePath)
}

UpdateDataInJSON(dataArray, index, filePath) {
    FileRead(jsonData,filePath)
    data := JsonLoad(jsonData)
    Loop dataArray.MaxIndex() {
        col := dataArray[A_Index]
        if (IsObject(col)) {
            colName := col.0
            colValue := col.1
            data[index][colName] := colValue
        }
    }
    json := JsonDump(data)
    FileDelete(filePath)
    FileAppend(json,filePath)
}
