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
			_serialPort = new SerialPort("COM4", 115200); // Cambia COM3 por tu puerto
			_serialPort.ReadTimeout = 100;
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

	public override void _ExitTree()
	{
		if (_serialPort != null && _serialPort.IsOpen)
		{
			_serialPort.Close();
			GD.Print("Puerto serial cerrado");
		}
	}
