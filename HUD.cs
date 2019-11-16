using Godot;
using System;

public class HUD : CanvasLayer
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";
    [Signal]
    public delegate void StartGame();
    
    // Called when the node enters the scene tree for the first time.
    
    public void ShowMessage(string text)
    {
        var messageLabel = GetNode<Label>("MessageLabel");
        messageLabel.Text = text;
        messageLabel.Show();
    
        GetNode<Timer>("MessageTimer").Start();
    }
    async public void ShowGameOver()
    {
        ShowMessage("Game Over");
    
        var messageTimer = GetNode<Timer>("MessageTimer");
        await ToSignal(messageTimer, "timeout");
    
        var messageLabel = GetNode<Label>("MessageLabel");
        messageLabel.Text = "Dodge the\nCreeps!";
        messageLabel.Show();
    
        GetNode<Button>("StartButton").Show();
    }
    public void UpdateScore(int score)
    {
        GetNode<Label>("ScoreLabel").Text = score.ToString();
    }
    public void OnStartButtonPressed()
    {
        GetNode<Button>("StartButton").Hide();
        //GD.Print("To emit"); 
        EmitSignal("StartGame");
        //GD.Print("or.. not?");
    }
    
    public void OnMessageTimerTimeout()
    {
        GetNode<Label>("MessageLabel").Hide();
    }   
    public override void _Ready()
    {
        
        GetNode("StartButton").Connect("pressed", this, nameof(OnStartButtonPressed));
        GetNode("MessageTimer").Connect("timeout", this, nameof(OnMessageTimerTimeout));
        GD.Print("HUD READY");
    }
//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
