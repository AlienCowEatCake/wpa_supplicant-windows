#ifndef STANDALONE_H
#define STANDALONE_H

#include <cstring>

#include <QList>
#include <QReadWriteLock>
#include <QThread>

struct wpa_supplicant;
struct wpa_global;

struct ctrl_iface_priv;
struct ctrl_iface_global_priv;
struct wpa_ctrl;

class StandaloneSupplicant : public QThread
{
private:
	StandaloneSupplicant(QObject *parent = NULL);
	~StandaloneSupplicant();

	wpa_supplicant *get_supplicant(const wpa_ctrl *ctrl);

public:
	static StandaloneSupplicant *instance();

	// service
	int wpa_supplicant_run_call(struct wpa_global *global);

	// supplicant
	void wpa_supplicant_ctrl_iface_init(ctrl_iface_priv *priv);
	void wpa_supplicant_ctrl_iface_deinit(ctrl_iface_priv *priv);
	void wpa_supplicant_ctrl_iface_wait(ctrl_iface_priv *priv);
	void wpa_supplicant_global_ctrl_iface_init(ctrl_iface_global_priv *priv);
	void wpa_supplicant_global_ctrl_iface_deinit(ctrl_iface_global_priv *priv);

	// gui
	void wpa_ctrl_open(wpa_ctrl *ctrl);
	void wpa_ctrl_close(wpa_ctrl *ctrl);
	int wpa_ctrl_request(wpa_ctrl *ctrl, const char *cmd, size_t cmd_len, char *reply, size_t *reply_len);
	int wpa_ctrl_attach(wpa_ctrl *ctrl);
	int wpa_ctrl_detach(wpa_ctrl *ctrl);

public:
	void stop();

protected:
	void run();
	void reset();

private:
	QReadWriteLock m_ctrl_ifaces_lock;
	QList<ctrl_iface_priv*> m_ctrl_ifaces;
	QReadWriteLock m_global_lock;
	ctrl_iface_global_priv *m_global;
	bool m_supplicant_running;
};

#endif /* STANDALONE_H */
