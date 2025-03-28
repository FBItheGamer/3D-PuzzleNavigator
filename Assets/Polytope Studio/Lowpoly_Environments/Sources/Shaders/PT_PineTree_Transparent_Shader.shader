// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polytope Studio/PT_PineTree_Transparent_Shader"
{
    Properties
    {
        [NoScaleOffset] _BaseTexture("Base Texture", 2D) = "white" {}
        [Toggle] _CUSTOMCOLORSTINTING("CUSTOM COLORS TINTING", Float) = 0
        [HDR] _TopColor("Top Color", Color) = (0,0.2178235,1,1)
        [HDR] _GroundColor("Ground Color", Color) = (1,0,0,1)
        [HDR] _Gradient("Gradient", Range(0, 1)) = 1
        _GradientPower("Gradient Power", Range(0, 10)) = 5
        _LeavesThickness("Leaves Thickness", Range(0.1, 0.95)) = 0.5
        _Smoothness("Smoothness", Range(0, 1)) = 0
        [Toggle(_TRANSLUCENCYONOFF_ON)] _TRANSLUCENCYONOFF("TRANSLUCENCY ON/OFF", Float) = 1
        [Header(Translucency)]
        _Translucency("Strength", Range(0, 50)) = 1
        _TransNormalDistortion("Normal Distortion", Range(0, 1)) = 0.1
        _TransScattering("Scattering Falloff", Range(1, 50)) = 2
        _TransDirect("Direct", Range(0, 1)) = 1
        _TransAmbient("Ambient", Range(0, 1)) = 0.2
        _TransShadow("Shadow", Range(0, 1)) = 0.9
        [HideInInspector] _MaskClipValue("Mask Clip Value", Range(0, 1)) = 0.5
        [Toggle(_CUSTOMWIND_ON)] _CUSTOMWIND("CUSTOM WIND", Float) = 1
        [Toggle(_WINDMASKONOFF_ON)] _WINDMASKONOFF("WIND MASK ON/OFF", Float) = 0
        _WindMovement("Wind Movement", Range(0, 10)) = 0.5
        _WindDensity("Wind Density", Range(0, 5)) = 3.3
        _WindStrength("Wind Strength", Range(0, 1)) = 0.3
        [Toggle(_SNOWONOFF_ON)] _SNOWONOFF("SNOW ON/OFF", Float) = 0
        _SnowGradient("Snow Gradient", Range(0, 1)) = 0.83
        _SnowCoverage("Snow Coverage", Range(0, 1)) = 0.45
        _SnowAmount("Snow Amount", Range(0, 1)) = 1
        [HideInInspector] _texcoord("", 2D) = "white" {}
        [HideInInspector] __dirty("", Int) = 1
    }

    SubShader
    {
        Tags { "RenderType"="TransparentCutout" "Queue"="Geometry+0" "DisableBatching"="True" }
        Pass
        {
            Name "ForwardBase"
            Tags { "LightMode"="UniversalForward" }

            HLSLPROGRAM
            #pragma multi_compile_fog
            #pragma target 4.5
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            // Declare properties
            TEXTURE2D(_BaseTexture);
            SAMPLER(sampler_BaseTexture);

            float4 _TopColor;
            float4 _GroundColor;
            float _Gradient;
            float _GradientPower;
            float _LeavesThickness;
            float _Smoothness;
            float _Translucency;
            float _TransNormalDistortion;
            float _TransScattering;
            float _TransDirect;
            float _TransAmbient;
            float _TransShadow;
            float _WindMovement;
            float _WindDensity;
            float _WindStrength;
            float _MaskClipValue;
            float _SnowAmount;
            float _SnowGradient;
            float _SnowCoverage;
            float _SNOWONOFF_ON;

            struct Attributes
            {
                float3 position : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
                float4 position : SV_POSITION;
            };

            // Vertex Shader
            Varyings vert(Attributes v)
            {
                Varyings o;
                o.position = TransformObjectToHClip(v.position);
                o.worldPos = mul(unity_ObjectToWorld, float4(v.position, 1.0)).xyz;
                o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                o.uv = v.uv;
                return o;
            }

            // Fragment Shader
            half4 frag(Varyings i) : SV_Target
            {
                // Sample the base texture to get the color
                half4 texColor = tex2D(sampler_BaseTexture, i.uv);  // texColor is the sampled texture color

                // Gradient calculation based on world position
                float gradientFactor = clamp(pow(clamp(0.5 + (i.worldPos.y - 0.0) * (2.0 - 0.5) / (1.0 - 0.0), 0.0, 1.0) * _Gradient, _GradientPower), -1.0, 1.0);

                half4 gradientColor = lerp(_GroundColor, _TopColor, gradientFactor);

                // Simulate translucency (adjust texture color based on translucency)
                half3 finalColor = texColor.rgb * gradientColor.rgb * _Translucency;

                // Add custom wind effects (assuming you have wind strength and other parameters)
                half windEffect = sin(i.worldPos.x * _WindMovement + _Time.y) * _WindStrength;
                finalColor += windEffect * _WindDensity;

                // Apply snow effect if enabled
                if (_SNOWONOFF_ON > 0.5)
                {
                    finalColor *= _SnowAmount * _SnowCoverage;
                }

                // Apply smoothness (final color adjustment for smoothness)
                finalColor = finalColor * _Smoothness;

                // Return the final color as half4, combining the final color with alpha from texture
                return half4(finalColor, texColor.a);
                }

            ENDHLSL
        }
    }

    FallBack "Diffuse"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.CommentaryNode;544;-1538.46,-972.0139;Inherit;False;1541.214;770.4899;GRADIENT;11;557;738;556;553;547;546;744;747;746;739;558;GRADIENT;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;739;-1523.9,-552.8172;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;301;-3505.519,1070.215;Inherit;False;3563.478;765.4585;WIND;23;319;318;317;314;316;315;313;311;309;310;308;307;306;304;305;302;303;320;353;745;771;779;780;WIND;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;546;-1475.624,-318.8477;Float;False;Property;_Gradient;Gradient;4;1;[HDR];Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;744;-1326.038,-514.4321;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;547;-1110.976,-512.754;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;746;-1187.027,-304.8759;Inherit;False;Property;_GradientPower;Gradient Power;5;0;Create;True;0;0;0;False;0;False;5;10;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;39;-2704.9,-111.1786;Inherit;False;2726.816;529.2971;COLOR;9;505;502;336;18;352;728;180;2;127;COLOR;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;747;-920.3145,-512.8779;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;553;-1400.975,-729.489;Float;False;Property;_TopColor;Top Color;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0.2178235,1,1;0.05298166,0.3490566,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;127;-2684.817,-34.12083;Inherit;True;Property;_BaseTexture;Base Texture;0;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ClampOpNode;738;-745.4936,-681.0336;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;556;-1398.07,-934.2432;Float;False;Property;_GroundColor;Ground Color;3;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,1;0.01743852,0.5754717,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-2291.393,-5.608733;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;557;-602.1736,-865.377;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;180;-1770.382,24.23656;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;363;-1660.093,1917.527;Inherit;False;1693.406;1367.284;Comment;15;489;467;458;531;532;452;454;535;446;455;443;445;528;529;527;SNOW;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;558;-240.0452,-848.7395;Inherit;False;GRADIENT;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;529;-1476.111,3139.16;Inherit;False;Constant;_Float0;Float 0;22;0;Create;True;0;0;0;False;0;False;0.65;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;527;-1439.001,2972.903;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;445;-1208.042,2744.531;Inherit;True;Property;_SnowCoverage;Snow Coverage;24;0;Create;True;0;0;0;False;0;False;0.45;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;352;-1383.648,232.0044;Inherit;False;558;GRADIENT;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;728;-1581.035,24.87127;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;455;-874.9898,2746.986;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;443;-1619.278,2272.284;Inherit;False;Constant;_Color1;Color 1;30;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;446;-1546.916,2009.55;Inherit;False;Property;_SnowAmount;Snow Amount;25;0;Create;True;0;0;0;False;0;False;1;0.82;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;528;-1139.862,3021.589;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;18;-1189.932,-13.21011;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;741;-1203.495,556.3467;Inherit;False;1198.91;343.9196;Comment;6;106;128;107;116;740;496;ALPHA;1,1,1,1;0;0
Node;AmplifyShaderEditor.FresnelNode;454;-1385.883,2183.992;Inherit;False;Standard;WorldNormal;ViewDir;True;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0.11;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;535;-628.894,2708.991;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;336;-863.1887,-66.5021;Inherit;False;Property;_CUSTOMCOLORSTINTING;CUSTOM COLORS  TINTING;1;0;Create;True;0;0;0;False;0;False;0;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;452;-1158.428,2021.16;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;532;-895.5118,2301.897;Inherit;False;Property;_SnowGradient;Snow Gradient;23;0;Create;True;0;0;0;False;0;False;0.83;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;365;-1053.508,3402.887;Inherit;False;1092.364;358.1904;Comment;5;497;493;486;491;481;TRANSLUCENCY;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;505;-1962.379,200.54;Inherit;False;GENERALALPHA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;531;-533.8249,2342.536;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-1153.495,673.434;Inherit;False;Property;_LeavesThickness;Leaves Thickness;6;0;Create;True;0;0;0;False;0;False;0.5;0.346;0.1;0.95;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;502;-200.9671,-35.26162;Inherit;False;COLOR;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;458;-903.7538,2134.55;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;467;-402.3637,2148.709;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;486;-960.4905,3525.454;Inherit;False;Constant;_Float6;Float 6;15;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;740;-847.2863,606.3467;Inherit;False;505;GENERALALPHA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;481;-988.546,3440.888;Inherit;False;502;COLOR;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;128;-860.5824,695.5936;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;489;-226.8627,2133.406;Inherit;True;SNOW;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;491;-703.1473,3498.23;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;107;-634.9,638.9446;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;116;-414.9932,646.2662;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;367;1311.255,298.9597;Inherit;True;502;COLOR;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;493;-538.4254,3469.279;Inherit;True;Property;_TRANSLUCENCYONOFF;TRANSLUCENCY ON/OFF;8;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;366;1350.336,516.4232;Inherit;False;489;SNOW;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;368;1567.299,408.4161;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;497;-230.6066,3468.484;Inherit;False;TRANSLUCENCY;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;496;-229.5852,647.0934;Inherit;False;ALPHACUTOFF;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;507;1729.641,466.1032;Inherit;False;497;TRANSLUCENCY;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;354;1386.197,625.6137;Inherit;False;353;LOCALWIND;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;372;1718.154,296.2032;Inherit;False;Property;_SNOWONOFF;SNOW ON/OFF;22;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;742;1770.503,401.9955;Inherit;False;Property;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;2085.109,83.74197;Inherit;False;Property;_MaskClipValue;Mask Clip Value;16;1;[HideInInspector];Fetch;True;0;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;506;1738.329,541.7998;Inherit;False;496;ALPHACUTOFF;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;62;2050.875,301.853;Float;False;True;-1;3;;0;0;Standard;Polytope Studio/PT_Vegetation_Foliage_Shader;False;False;False;False;False;False;False;False;False;False;False;False;True;True;False;False;True;False;False;False;False;Off;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Absolute;0;;-1;9;-1;-1;0;False;0;0;False;;-1;0;True;_MaskClipValue;1;Pragma;multi_compile __ LOD_FADE_CROSSFADE;False;;Custom;False;0;0;;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleTimeNode;303;-3409.922,1399.411;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;302;-3480.34,1528.535;Inherit;False;Property;_WindMovement;Wind Movement;19;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;-3215.934,1402.35;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;305;-3308.347,1106.357;Inherit;False;1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;307;-3161.859,1531.835;Inherit;False;Property;_WindDensity;Wind Density;20;0;Create;True;0;0;0;False;0;False;3.3;1.91;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;306;-3072.247,1296.832;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;308;-2844.522,1309.064;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;309;-2638.732,1321.662;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;745;-2498.886,1316.177;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;771;-2962.363,1637.188;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;310;-2831.992,1556.02;Inherit;False;Property;_WindStrength;Wind Strength;21;0;Create;True;0;0;0;False;0;False;0.3;0.203;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;779;-2705.279,1676.25;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;-2374.085,1314.555;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;312;-2926.161,1831.492;Inherit;False;Constant;_VertexMask;Vertex Mask;21;0;Create;True;0;0;0;False;0;False;5;0.5;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;-2460.429,1556.756;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;313;-2227.393,1217.466;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;316;-1977.25,1158.37;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;780;-2218.305,1504.024;Inherit;False;Property;_WINDMASKONOFF;WIND MASK ON/OFF;18;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;314;-1856.501,1459.499;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;317;-1732.488,1173.202;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;318;-1607.435,1452.75;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;319;-1434.47,1191.707;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;320;-1191.573,1103.98;Inherit;True;Property;_CUSTOMWIND;CUSTOM WIND;17;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;False;True;All;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;353;-446.7983,1106.672;Inherit;True;LOCALWIND;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
WireConnection;744;0;739;2
WireConnection;547;0;744;0
WireConnection;547;1;546;0
WireConnection;747;0;547;0
WireConnection;747;1;746;0
WireConnection;738;0;747;0
WireConnection;2;0;127;0
WireConnection;557;0;556;0
WireConnection;557;1;553;0
WireConnection;557;2;738;0
WireConnection;180;0;2;0
WireConnection;558;0;557;0
WireConnection;728;1;180;0
WireConnection;455;0;445;0
WireConnection;528;0;527;2
WireConnection;528;1;529;0
WireConnection;18;0;728;0
WireConnection;18;1;352;0
WireConnection;454;3;443;0
WireConnection;535;0;528;0
WireConnection;535;1;455;0
WireConnection;336;0;2;0
WireConnection;336;1;18;0
WireConnection;452;0;446;0
WireConnection;505;0;2;4
WireConnection;531;0;535;0
WireConnection;531;2;532;0
WireConnection;502;0;336;0
WireConnection;458;0;452;0
WireConnection;458;1;454;0
WireConnection;467;0;458;0
WireConnection;467;1;531;0
WireConnection;128;0;106;0
WireConnection;489;0;467;0
WireConnection;491;0;481;0
WireConnection;491;1;486;0
WireConnection;107;0;740;0
WireConnection;107;1;128;0
WireConnection;116;0;107;0
WireConnection;493;0;491;0
WireConnection;368;0;366;0
WireConnection;368;1;367;0
WireConnection;497;0;493;0
WireConnection;496;0;116;0
WireConnection;372;1;367;0
WireConnection;372;0;368;0
WireConnection;62;0;372;0
WireConnection;62;4;742;0
WireConnection;62;7;507;0
WireConnection;62;10;506;0
WireConnection;62;11;354;0
WireConnection;304;0;303;0
WireConnection;304;1;302;0
WireConnection;306;0;305;0
WireConnection;306;2;304;0
WireConnection;308;0;306;0
WireConnection;308;1;307;0
WireConnection;309;0;308;0
WireConnection;745;0;309;0
WireConnection;779;0;771;2
WireConnection;311;0;745;0
WireConnection;311;1;310;0
WireConnection;315;0;779;0
WireConnection;315;1;312;0
WireConnection;313;0;311;0
WireConnection;313;1;305;1
WireConnection;316;0;313;0
WireConnection;316;1;305;2
WireConnection;316;2;305;3
WireConnection;780;1;305;2
WireConnection;780;0;315;0
WireConnection;317;0;305;0
WireConnection;317;1;316;0
WireConnection;317;2;780;0
WireConnection;318;0;314;0
WireConnection;319;0;317;0
WireConnection;319;1;318;4
WireConnection;320;1;305;0
WireConnection;320;0;319;0
WireConnection;353;0;320;0
ASEEND*/
//CHKSM=4662F1ECAD2AE0091C5C8985BB72FFBB9143BF38