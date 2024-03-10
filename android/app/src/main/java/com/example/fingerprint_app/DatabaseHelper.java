package com.example.fingerprint_app;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import java.util.ArrayList;
import java.util.List;

public class DatabaseHelper extends SQLiteOpenHelper {

    private static final String DATABASE_NAME = "fingerprint_database.db";
    private static final int DATABASE_VERSION = 1;
    private static final String TABLE_NAME = "fingerprint_records";
    private static final String COLUMN_ID = "id";
    private static final String COLUMN_DATE_CREATED = "dateCreated";
    private static final String COLUMN_FINGERPRINT_PATH = "fingerprintPath";

    public DatabaseHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        // Your table creation logic, you can copy it from Dart's _createDatabase method
        // Be sure to match column names and data types
        db.execSQL("CREATE TABLE " + TABLE_NAME + "(" +
                COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
                COLUMN_DATE_CREATED + " TEXT, " +
                COLUMN_FINGERPRINT_PATH + " TEXT" +
                ")");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // Handle database upgrades, if needed
    }




    public List<FingerprintModel> queryFingerprintRecords() {
        List<FingerprintModel> fingerprintList = new ArrayList<>();

        SQLiteDatabase db = getReadableDatabase();
        String[] projection = {COLUMN_ID, COLUMN_DATE_CREATED, COLUMN_FINGERPRINT_PATH};

        Cursor cursor = db.query(
                TABLE_NAME,
                projection,
                null,
                null,
                null,
                null,
                null
        );

        while (cursor.moveToNext()) {
            int id = cursor.getInt(cursor.getColumnIndexOrThrow(COLUMN_ID));
            String dateCreated = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_DATE_CREATED));
            String fingerprintPath = cursor.getString(cursor.getColumnIndexOrThrow(COLUMN_FINGERPRINT_PATH));

            FingerprintModel fingerprintModel = new FingerprintModel(id, dateCreated, fingerprintPath);
            fingerprintList.add(fingerprintModel);
        }

        cursor.close();
        db.close();

        return fingerprintList;
    }




    public class FingerprintModel {
        private int id;
        private String dateCreated;
        private String fingerprintPath;

        public FingerprintModel(int id, String dateCreated, String fingerprintPath) {
            this.id = id;
            this.dateCreated = dateCreated;
            this.fingerprintPath = fingerprintPath;
        }

        public int getId() {
            return id;
        }

        public String getDateCreated() {
            return dateCreated;
        }

        public String getFingerprintPath() {
            return fingerprintPath;
        }
    }

}

