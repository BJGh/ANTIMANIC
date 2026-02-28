package burin_zhargal.scheludemirea;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class Group extends AppCompatActivity  implements View.OnClickListener {
    Button groupselect;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_group);
        groupselect = findViewById(R.id.groupselect);
        groupselect.setOnClickListener(this);

    }

    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.groupselect:
                Intent intent = new Intent(Group.this, Schelude.class);
                startActivity(intent);
                break;
            default:
                break;
        }

    }
}
