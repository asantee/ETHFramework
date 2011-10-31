#include "IncludeModules.angelscript"

void main()
{
	g_scale.updateScaleFactor(DEFAULT_SCALE_HEIGHT);
	g_stateManager.setState(MainMenu());
	SetPersistentResources(true);
}

void loop()
{
	g_stateManager.runCurrentLoopFunction();
	//DrawText(vector2(0,30), "" + GetFPSRate() + "/" + GetNumEntities(), "Verdana20_shadow.fnt", 0xFFFFFFFF);
}

void preLoop()
{
	SetBackgroundColor(0xFFFF0000);
	// atualiza global scale para evitar dimensoes falsas do Xoom
	g_scale.updateScaleFactor(DEFAULT_SCALE_HEIGHT);
	g_stateManager.runCurrentPreLoopFunction();

	SetZBuffer(false);
	SetPositionRoundUp(false);
	SetFastGarbageCollector(false);
	SetNumIterations(8, 3);
}
