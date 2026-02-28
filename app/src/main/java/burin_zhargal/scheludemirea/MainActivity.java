package burin_zhargal.scheludemirea;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;


public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    Button button;


    @Override
    protected void onCreate(Bundle savedInstanceState) {

    super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        button = findViewById(R.id.button);
        button.setOnClickListener(this);

}


        public void onClick(View v) {
            switch (v.getId()) {
                case R.id.button:
                    Intent intent = new Intent(MainActivity.this, Group.class);
                    startActivity(intent);
                    break;
                default:
                    break;
            }

        }
}




