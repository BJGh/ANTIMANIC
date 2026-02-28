package burin_zhargal.scheludemirea;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class HelloActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Intent intent = new Intent(HelloActivity.this, MainActivity.class);
        startActivity(intent);
        finish();
    }
}