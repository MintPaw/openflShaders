package ;

import openfl.display.OpenGLView;
import openfl.display.Sprite;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.gl.GL;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;
import openfl.gl.GLUniformLocation;
import openfl.utils.ByteArray;
import openfl.utils.Float32Array;
import openfl.Assets;
import openfl.Lib;

class MintShader
{
	private static var backbufferUniform:GLUniformLocation;
	private static var buffer:GLBuffer;
	private static var currentIndex:Int;
	private static var currentProgram:GLProgram;
	private static var mouseUniform:GLUniformLocation;
	private static var positionAttribute:Int;
	private static var resolutionUniform:GLUniformLocation;
	private static var startTime:Int;
	private static var surfaceSizeUniform:GLUniformLocation;
	private static var timeUniform:GLUniformLocation;
	private static var vertexPosition:Int;
	private static var view:OpenGLView;
	private static var disp:Sprite;

	public static function init(disp:Sprite):Void
	{
		if (OpenGLView.isSupported) {
			view = new OpenGLView();

			currentIndex = 0;

			buffer = GL.createBuffer();
			GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
			GL.bufferData(GL.ARRAY_BUFFER, new Float32Array([ -1.0, -1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0 ]), GL.STATIC_DRAW);
			GL.bindBuffer(GL.ARRAY_BUFFER, null);

			view.render = renderView;
			disp.addChild(view);
		}
	}

	public static function compile(shaderPath:String):Void
	{

		var program:GLProgram = GL.createProgram();
		var vertex:String = Assets.getText("assets/shader/heroku.vert");

#if desktop
		var fragment:String = "";
#else
		var fragment:String = "precision mediump float;";
#end

		fragment += Assets.getText(shaderPath);

		var vs:GLShader = createShader(vertex, GL.VERTEX_SHADER);
		var fs:GLShader = createShader(fragment, GL.FRAGMENT_SHADER);

		if (vs == null || fs == null) return;

		GL.attachShader(program, vs);
		GL.attachShader(program, fs);

		GL.deleteShader(vs);
		GL.deleteShader(fs);

		GL.linkProgram(program);

		if (GL.getProgramParameter(program, GL.LINK_STATUS) == 0) {
			trace(GL.getProgramInfoLog(program));
			trace("VALIDATE_STATUS: " + GL.getProgramParameter(program, GL.VALIDATE_STATUS));
			trace("ERROR: " + GL.getError());
			return;
		}

		if (currentProgram != null) GL.deleteProgram(currentProgram);

		currentProgram = program;

		positionAttribute = GL.getAttribLocation(currentProgram, "surfacePosAttrib");
		GL.enableVertexAttribArray(positionAttribute);

		vertexPosition = GL.getAttribLocation(currentProgram, "position");
		GL.enableVertexAttribArray(vertexPosition);

		timeUniform = GL.getUniformLocation(program, "time");
		mouseUniform = GL.getUniformLocation(program, "mouse");
		resolutionUniform = GL.getUniformLocation(program, "resolution");
		backbufferUniform = GL.getUniformLocation(program, "backbuffer");
		surfaceSizeUniform = GL.getUniformLocation(program, "surfaceSize");
	}

	private static function createShader(source:String, type:Int):GLShader
	{
		var shader:GLShader = GL.createShader(type);
		GL.shaderSource(shader, source);
		GL.compileShader(shader);

		if (GL.getShaderParameter(shader, GL.COMPILE_STATUS) == 0) {
			trace(GL.getShaderInfoLog(shader));
			return null;
		}

		return shader;
	}

	private static function renderView(rect:Rectangle):Void
	{
		GL.viewport(Std.int(rect.x), Std.int(rect.y), Std.int(rect.width), Std.int(rect.height));

		if (currentProgram == null) return;

		var time = Lib.getTimer() - startTime;

		GL.useProgram(currentProgram);

		GL.uniform1f(timeUniform, time / 1000);
		GL.uniform2f(mouseUniform, 0.1, 0.1); //GL.uniform2f(mouseUniform,(stage.mouseX / stage.stageWidth) * 2 - 1,(stage.mouseY / stage.stageHeight) * 2 - 1);
		GL.uniform2f(resolutionUniform, rect.width, rect.height);
		GL.uniform1i(backbufferUniform, 0 );
		GL.uniform2f(surfaceSizeUniform, rect.width, rect.height);

		GL.bindBuffer(GL.ARRAY_BUFFER, buffer);
		GL.vertexAttribPointer(positionAttribute, 2, GL.FLOAT, false, 0, 0);
		GL.vertexAttribPointer(vertexPosition, 2, GL.FLOAT, false, 0, 0);

		GL.clearColor(0, 0, 0, 1);
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT );
		GL.drawArrays(GL.TRIANGLES, 0, 6);
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
	}
}