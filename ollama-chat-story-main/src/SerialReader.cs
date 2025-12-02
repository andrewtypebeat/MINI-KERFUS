using Godot;
using System;
using System.IO.Ports;

public partial class SerialReader : Node
{
	private SerialPort _serialPort;

	public int Input1 { get; private set; }
	public int Input2 { get; private set; }

	public override void _Ready()
	{
		try
		{
			_serialPort = new SerialPort("COM4", 115200);
			_serialPort.ReadTimeout = 100;
			_serialPort.WriteTimeout = 100;
			_serialPort.Open();

			GD.Print("Puerto serial abierto");
		}
		catch (Exception e)
		{
			GD.PrintErr($"Error abriendo puerto serial: {e.Message}");
		}
	}

	public override void _Process(double delta)
	{
		if (_serialPort != null && _serialPort.IsOpen)
		{
			// --- LECTURA DESDE ARDUINO ---
			try
			{
				string line = _serialPort.ReadLine();
				string[] parts = line.Trim().Split(',');

				if (parts.Length >= 2)
				{
					if (int.TryParse(parts[0], out int val1))
						Input1 = val1;

					if (int.TryParse(parts[1], out int val2))
						Input2 = val2;
				}
			}
			catch (TimeoutException)
			{
				// Sin datos, continuar
			}
			catch (Exception e)
			{
				GD.PrintErr($"Error leyendo puerto serial: {e.Message}");
			}
		}
	}

	// --- FUNCIÓN NUEVA PARA ENVIAR DATOS A ARDUINO ---
	public void SendToArduino(string message)
	{
		if (_serialPort != null && _serialPort.IsOpen)
		{
			try
			{
				_serialPort.WriteLine(message);
				GD.Print($"Enviado a Arduino: {message}");
			}
			catch (Exception e)
			{
				GD.PrintErr($"Error enviando datos: {e.Message}");
			}
		}
	}
	public void SetServoAngle(int angle)
{
	if (_serialPort != null && _serialPort.IsOpen)
	{
		try
		{
			string msg = $"SERVO:{angle}";
			_serialPort.WriteLine(msg);
			GD.Print($"Enviado → {msg}");
		}
		catch (Exception e)
		{
			GD.PrintErr($"Error enviando comando: {e.Message}");
		}
	}
}



	public override void _ExitTree()
	{
		if (_serialPort != null && _serialPort.IsOpen)
		{
			_serialPort.Close();
			GD.Print("Puerto serial cerrado");
		}
	}
}
